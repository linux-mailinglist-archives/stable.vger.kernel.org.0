Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2E5D3DD96D
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237005AbhHBOAW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:00:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:43164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234352AbhHBN6Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:58:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 392FB61163;
        Mon,  2 Aug 2021 13:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912513;
        bh=p/hy57zoVLv+fl86AipyuHLZj9E7DPReKCOYWSqs3mc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gz3qvPek1zh9pab+9m8ADU7n18AtNW/G5Sdy37fCIJh1R3izfEjJXk9n2+dccfoVR
         pE/mWDM0lqHCCNJnhUxWgW7CeHdoxVDqSVR2QBzNP03yckm7lbMkkXs+ZiRgfX/5Qz
         EGTBNWhWjD7ylJ3+VjWkEnqbIaEsTO6Q0LQ8x/IQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vojtech Pavlik <vojtech@ucw.cz>,
        Jiri Kosina <jkosina@suse.cz>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.13 027/104] drm/amdgpu: Avoid printing of stack contents on firmware load error
Date:   Mon,  2 Aug 2021 15:44:24 +0200
Message-Id: <20210802134344.912870775@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
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


