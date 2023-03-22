Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1BD46C5728
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 21:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232210AbjCVUNy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 16:13:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231558AbjCVUNh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 16:13:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73E066E680;
        Wed, 22 Mar 2023 13:04:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B67FB81DFD;
        Wed, 22 Mar 2023 20:03:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D034C4339B;
        Wed, 22 Mar 2023 20:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515423;
        bh=uVI9bvcjhh5fMLFX4dlOB96QsXbr3zWKfyw4FSbntRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qiYz9zrKzTKiUczF8RF4XgogddgmbUvj2sHZ8QPsk/i+rVYxA3yjp2WVtEbmsqoBd
         Bwzl7NxZGgc1zePgawZ5/AVKsSAwFM0yMQLjNFiXFZytBhBtRmVm8g7pLnLWgz88oK
         0BA1Fk6aTY7cIiFiX7JgPdZZ7GWmTuZ9qk7IOj4x/c/0qkNmU5fMAX+v8DgM6FicQE
         qpW2JaKBPcvjlypoHd4yh6wH9jA34mWHuv68MTKlmjpDx2kR0Xjn0bmYduclDoT2Wu
         hu6xVY5UWaYJ5NbHwhW8xk0dbf7fsvRYmPtGw/hA8D9uZ6DNhos8150RbRJi+a6XZK
         lmHL6QNIvU4mw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        perex@perex.cz, tiwai@suse.com, dengshaomin@cdjrlc.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.14 2/9] ALSA: asihpi: check pao in control_message()
Date:   Wed, 22 Mar 2023 16:03:29 -0400
Message-Id: <20230322200337.1997810-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322200337.1997810-1-sashal@kernel.org>
References: <20230322200337.1997810-1-sashal@kernel.org>
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
index 8d5abfa4e24bf..bc694a69b4b79 100644
--- a/sound/pci/asihpi/hpi6205.c
+++ b/sound/pci/asihpi/hpi6205.c
@@ -441,7 +441,7 @@ void HPI_6205(struct hpi_message *phm, struct hpi_response *phr)
 		pao = hpi_find_adapter(phm->adapter_index);
 	} else {
 		/* subsys messages don't address an adapter */
-		_HPI_6205(NULL, phm, phr);
+		phr->error = HPI_ERROR_INVALID_OBJ_INDEX;
 		return;
 	}
 
-- 
2.39.2

