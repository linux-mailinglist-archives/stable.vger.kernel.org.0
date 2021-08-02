Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D56373DD8F3
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235734AbhHBN4A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:56:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:33720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236204AbhHBNzI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:55:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AFEA61168;
        Mon,  2 Aug 2021 13:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912417;
        bh=p/hy57zoVLv+fl86AipyuHLZj9E7DPReKCOYWSqs3mc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ticBjIn5FbcZBh4nNVk47ZpwWWtEcAiZZ3yBrWSH/DQhi7WwrH/qKG13l3lQKdtta
         Nq9lqMdmL6OF1XoaXU6fNjrqYsZTWkPd5vD8IFaQ4+UDHuZLxJYmuK7JEOQXdXmnAm
         2bUuKc8C23lwZXFY1ibXWndfQdqQ1UV1Qe85m4Hk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vojtech Pavlik <vojtech@ucw.cz>,
        Jiri Kosina <jkosina@suse.cz>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 23/67] drm/amdgpu: Avoid printing of stack contents on firmware load error
Date:   Mon,  2 Aug 2021 15:44:46 +0200
Message-Id: <20210802134339.807165343@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134339.023067817@linuxfoundation.org>
References: <20210802134339.023067817@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

commit 6aade587d329ebe88319dfdb8e8c7b6aede80417 upstream.

In case when psp_init_asd_microcode() fails to load ASD microcode file,
psp_v12_0_init_microcode() tries to print the firmware filename that
failed to load before bailing out.

This is wrong because:

- the firmware filename it would want it print is an incorrect one as
  psp_init_asd_microcode() and psp_v12_0_init_microcode() are loading
  different filenames
- it tries to print fw_name, but that's not yet been initialized by that
  time, so it prints random stack contents, e.g.

    amdgpu 0000:04:00.0: Direct firmware load for amdgpu/renoir_asd.bin failed with error -2
    amdgpu 0000:04:00.0: amdgpu: fail to initialize asd microcode
    amdgpu 0000:04:00.0: amdgpu: psp v12.0: Failed to load firmware "\xfeTO\x8e\xff\xff"

Fix that by bailing out immediately, instead of priting the bogus error
message.

Reported-by: Vojtech Pavlik <vojtech@ucw.cz>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/psp_v12_0.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/psp_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/psp_v12_0.c
@@ -67,7 +67,7 @@ static int psp_v12_0_init_microcode(stru
 
 	err = psp_init_asd_microcode(psp, chip_name);
 	if (err)
-		goto out;
+		return err;
 
 	snprintf(fw_name, sizeof(fw_name), "amdgpu/%s_ta.bin", chip_name);
 	err = request_firmware(&adev->psp.ta_fw, fw_name, adev->dev);
@@ -80,7 +80,7 @@ static int psp_v12_0_init_microcode(stru
 	} else {
 		err = amdgpu_ucode_validate(adev->psp.ta_fw);
 		if (err)
-			goto out2;
+			goto out;
 
 		ta_hdr = (const struct ta_firmware_header_v1_0 *)
 				 adev->psp.ta_fw->data;
@@ -105,10 +105,9 @@ static int psp_v12_0_init_microcode(stru
 
 	return 0;
 
-out2:
+out:
 	release_firmware(adev->psp.ta_fw);
 	adev->psp.ta_fw = NULL;
-out:
 	if (err) {
 		dev_err(adev->dev,
 			"psp v12.0: Failed to load firmware \"%s\"\n",


