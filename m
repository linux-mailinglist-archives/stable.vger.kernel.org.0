Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE53548C27
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358402AbiFMMGU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359285AbiFMMFh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:05:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4FD32613D;
        Mon, 13 Jun 2022 03:59:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC24CB80EA3;
        Mon, 13 Jun 2022 10:59:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C730C34114;
        Mon, 13 Jun 2022 10:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117989;
        bh=VYpgOJOZ3uKVM8B3ypZhsdk8jW/PVEnnQsj0lr/cyCA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B9pE+4gPMrWmm7In8d+w8LMWGqj81T/dYVKBRGUeUY78+Bayd1liX6sPDH7gI9Irc
         8YZqePZ7Y5oHU28P+MURQqD5qxDEinqwSPJNpzRqD1dnqBk9xCaPxLGg3gOZ4Eg0RE
         kw+PrVAAJKYRNLmHvvxPuofgC1xDPuKNZdfEA3ho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Vaibhav Agarwal <vaibhav.sr@gmail.com>,
        Mark Greer <mgreer@animalcreek.com>,
        Jakob Koschel <jakobkoschel@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 190/287] staging: greybus: codecs: fix type confusion of list iterator variable
Date:   Mon, 13 Jun 2022 12:10:14 +0200
Message-Id: <20220613094929.628742280@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094923.832156175@linuxfoundation.org>
References: <20220613094923.832156175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakob Koschel <jakobkoschel@gmail.com>

[ Upstream commit 84ef256550196bc06e6849a34224c998b45bd557 ]

If the list does not exit early then data == NULL and 'module' does not
point to a valid list element.
Using 'module' in such a case is not valid and was therefore removed.

Fixes: 6dd67645f22c ("greybus: audio: Use single codec driver registration")
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Vaibhav Agarwal <vaibhav.sr@gmail.com>
Reviewed-by: Mark Greer <mgreer@animalcreek.com>
Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
Link: https://lore.kernel.org/r/20220321123626.3068639-1-jakobkoschel@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/greybus/audio_codec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/greybus/audio_codec.c b/drivers/staging/greybus/audio_codec.c
index 6cbf69a57dfd..806be9d86338 100644
--- a/drivers/staging/greybus/audio_codec.c
+++ b/drivers/staging/greybus/audio_codec.c
@@ -620,8 +620,8 @@ static int gbcodec_mute_stream(struct snd_soc_dai *dai, int mute, int stream)
 			break;
 	}
 	if (!data) {
-		dev_err(dai->dev, "%s:%s DATA connection missing\n",
-			dai->name, module->name);
+		dev_err(dai->dev, "%s DATA connection missing\n",
+			dai->name);
 		mutex_unlock(&codec->lock);
 		return -ENODEV;
 	}
-- 
2.35.1



