Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04D6740E615
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346356AbhIPRSD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:18:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:39804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243964AbhIPRP6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:15:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B75D61B7C;
        Thu, 16 Sep 2021 16:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810398;
        bh=H90KaqeN0o0+Sxqny6vwEHWxYTdk8Hk8ctf9SPEmtQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ohvm/9e/m+0Yte/OpbrpxLkjMjIyC6EwanHMxayG8rA3qbt7h5feK+ZuXzp3t7Am2
         c/gp0NwMC3MIAw5rEpyir91CI/y3H3EMFeNtASrgszr5Mi5oUhhMwHix7jUXwYKw7G
         nEv1rTgnAdfrAXe8nrl5YTgBYq5wdKQOlkucn5aI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 125/432] HID: amd_sfh: Fix period data field to enable sensor
Date:   Thu, 16 Sep 2021 17:57:54 +0200
Message-Id: <20210916155814.990898739@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Basavaraj Natikar <Basavaraj.Natikar@amd.com>

[ Upstream commit 3978f54817559b28535c58a00d3d31bbd5d0b65a ]

Existing amd-sfh driver is programming the MP2 firmware period field in
units of jiffies, but the MP2 firmware expects in milliseconds unit.

Changing it to milliseconds.

Fixes: 4b2c53d93a4b ("SFH:Transport Driver to add support of AMD Sensor Fusion Hub (SFH)")
Reviewed-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/amd-sfh-hid/amd_sfh_client.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_client.c b/drivers/hid/amd-sfh-hid/amd_sfh_client.c
index efb849411d25..4710b9aa24a5 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_client.c
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_client.c
@@ -184,7 +184,7 @@ int amd_sfh_hid_client_init(struct amd_mp2_dev *privdata)
 			rc = -ENOMEM;
 			goto cleanup;
 		}
-		info.period = msecs_to_jiffies(AMD_SFH_IDLE_LOOP);
+		info.period = AMD_SFH_IDLE_LOOP;
 		info.sensor_idx = cl_idx;
 		info.dma_address = cl_data->sensor_dma_addr[i];
 
-- 
2.30.2



