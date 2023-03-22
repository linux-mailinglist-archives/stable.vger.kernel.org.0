Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E24206C57D9
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 21:42:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbjCVUmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 16:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231192AbjCVUl6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 16:41:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9240D6C1BA;
        Wed, 22 Mar 2023 13:34:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1D5AB81DE9;
        Wed, 22 Mar 2023 20:00:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E2A2C433D2;
        Wed, 22 Mar 2023 20:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515250;
        bh=YpKGVIZwXXwpPXYfMjguBK41oZD5x+E7M/c8749YMQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OAnDnNs13B4Nm8s9/T8W/PE4EmGb3rWEzjdzqszpyojG/dmdD/2q7sScgdJvrzZvT
         Iwmd7Ry6QBCPmsegZBAsjXpVfDFzO1iovfkor3aH2uueR1TkJXRTiN5F18xiNDpStL
         Rf08sGSJImQzCQVwFqUJLNPjeHgDt/YSn4VLBnryUUfglL3oOYHalRbCe5SGxgjNyw
         lPLTGyTED4AhVrPU9onBvRGluHaQsaqTwaZFSF2CiClfdJ2MhgFdXlACuIeKbNVRhR
         YdjkcSr2FsPHYb0A37b38lC+gCH5UhK7efGFWByt0cR4bCMPfl9Y3i3QVIq8lCQxsY
         Ivp3NIazdDCCA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        perex@perex.cz, tiwai@suse.com, dengshaomin@cdjrlc.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 6.1 20/34] ALSA: asihpi: check pao in control_message()
Date:   Wed, 22 Mar 2023 15:59:12 -0400
Message-Id: <20230322195926.1996699-20-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322195926.1996699-1-sashal@kernel.org>
References: <20230322195926.1996699-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit 9026c0bf233db53b86f74f4c620715e94eb32a09 ]

control_message() might be called with pao = NULL.
Here indicates control_message() as sample.

(B)	static void control_message(struct hpi_adapter_obj *pao, ...)
	{                                                   ^^^
		struct hpi_hw_obj *phw = pao->priv;
		...                      ^^^
	}

(A)	void _HPI_6205(struct hpi_adapter_obj *pao, ...)
	{                                      ^^^
		...
		case HPI_OBJ_CONTROL:
(B)			control_message(pao, phm, phr);
			break;          ^^^
		...
	}

	void HPI_6205(...)
	{
		...
(A)		_HPI_6205(NULL, phm, phr);
		...       ^^^^
	}

Therefore, We will get too many warning via cppcheck, like below

	sound/pci/asihpi/hpi6205.c:238:27: warning: Possible null pointer dereference: pao [nullPointer]
		 struct hpi_hw_obj *phw = pao->priv;
		                          ^
	sound/pci/asihpi/hpi6205.c:433:13: note: Calling function '_HPI_6205', 1st argument 'NULL' value is 0
		  _HPI_6205(NULL, phm, phr);
		            ^
	sound/pci/asihpi/hpi6205.c:401:20: note: Calling function 'control_message', 1st argument 'pao' value is 0
	   control_message(pao, phm, phr);
	                   ^
Set phr->error like many functions doing, and don't call _HPI_6205()
with NULL.

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://lore.kernel.org/r/87ttypeaqz.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/asihpi/hpi6205.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/asihpi/hpi6205.c b/sound/pci/asihpi/hpi6205.c
index 27e11b5f70b97..c7d7eff86727f 100644
--- a/sound/pci/asihpi/hpi6205.c
+++ b/sound/pci/asihpi/hpi6205.c
@@ -430,7 +430,7 @@ void HPI_6205(struct hpi_message *phm, struct hpi_response *phr)
 		pao = hpi_find_adapter(phm->adapter_index);
 	} else {
 		/* subsys messages don't address an adapter */
-		_HPI_6205(NULL, phm, phr);
+		phr->error = HPI_ERROR_INVALID_OBJ_INDEX;
 		return;
 	}
 
-- 
2.39.2

