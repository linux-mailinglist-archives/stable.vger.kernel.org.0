Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3AB4ABB36
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384281AbiBGL1W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:27:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381883AbiBGLRj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:17:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32A16C0401DB;
        Mon,  7 Feb 2022 03:17:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2AA5EB8111C;
        Mon,  7 Feb 2022 11:17:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69043C004E1;
        Mon,  7 Feb 2022 11:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232649;
        bh=p/9Eah5nhtugNJaw6mXassHwYlybfO93r0QZ0+5hfdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UZtO75zNXVgXioZWr7xPgZa1bmAaDRfIYxSJhwAsoq7sn/bIYdRDNE0foG9JbaYHS
         DZP8uKIIir1GbPV1s56QAzoMxafJS+5SUG2BJleCI1RiUEqseG0/g8z0ZoMFehh7hb
         q2htUb/RAXgJBTWA0gIzR85slbNseJW+c7rmYAug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.19 78/86] ASoC: cpcap: Check for NULL pointer after calling of_get_child_by_name
Date:   Mon,  7 Feb 2022 12:06:41 +0100
Message-Id: <20220207103800.227001691@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103757.550973048@linuxfoundation.org>
References: <20220207103757.550973048@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

commit f7a6021aaf02088870559f82fc13c58cda7fea1a upstream.

If the device does not exist, of_get_child_by_name() will return NULL
pointer.
And devm_snd_soc_register_component() does not check it.
Also, I have noticed that cpcap_codec_driver has not been used yet.
Therefore, it should be better to check it in order to avoid the future
dereference of the NULL pointer.

Fixes: f6cdf2d3445d ("ASoC: cpcap: new codec")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Link: https://lore.kernel.org/r/20220111025048.524134-1-jiasheng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/cpcap.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/soc/codecs/cpcap.c
+++ b/sound/soc/codecs/cpcap.c
@@ -1541,6 +1541,8 @@ static int cpcap_codec_probe(struct plat
 {
 	struct device_node *codec_node =
 		of_get_child_by_name(pdev->dev.parent->of_node, "audio-codec");
+	if (!codec_node)
+		return -ENODEV;
 
 	pdev->dev.of_node = codec_node;
 


