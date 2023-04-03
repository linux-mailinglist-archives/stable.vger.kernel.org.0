Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 179C26D4715
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232900AbjDCOQ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:16:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232956AbjDCOQ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:16:57 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F4F727825
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:16:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A3E89CE12B3
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:16:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1C7EC433D2;
        Mon,  3 Apr 2023 14:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531413;
        bh=elbZTfnoO9XGtb/v16KA9+EzqGYnj10HocvDxBVSs5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uk5o+q+gc3m9MXEfkEuN7iQDqEcGka64Dx+fUXHIfsuIuERTHPbvfHsBpJpGTnHHa
         d3a7G4SKrvgCY2b/e2+XU7S9BqTXgi+VHs5ugHJqK3BdvBf57W6t/PZA9I2M0waSf3
         Q4dZNRvQeV7WKqCXewK9CPGmkWttQGMXlZR8/TfU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 53/84] ALSA: asihpi: check pao in control_message()
Date:   Mon,  3 Apr 2023 16:08:54 +0200
Message-Id: <20230403140355.240909283@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140353.406927418@linuxfoundation.org>
References: <20230403140353.406927418@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 2864698436a5f..6a49f897c4d91 100644
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



