Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DAB1549116
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358377AbiFMMzU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355207AbiFMMxg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:53:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 822571EAE4;
        Mon, 13 Jun 2022 04:12:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3941A60B6B;
        Mon, 13 Jun 2022 11:12:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 470B9C34114;
        Mon, 13 Jun 2022 11:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118757;
        bh=VMEpLp3jl/DqBn9a/YOkRUBB4mDMM4VZdl9IrsDdYLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YBch0KqCzXVA1JXsFn024I46KGhIBViwUMa/pg43qM9dRcepL/+uAstASSrwmHOWJ
         ZBZ8qbku3ax8IsLnzTEuTNAYPbwcXmgMh2lxgcfdEzJC8lmSoeyR72F6QUzoxpWpx7
         JlCCNd0RLBN/2EgoN5avl2Xpc4ODN/pthVL5PiNI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Vaibhav Agarwal <vaibhav.sr@gmail.com>,
        Mark Greer <mgreer@animalcreek.com>,
        Jakob Koschel <jakobkoschel@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 002/247] staging: greybus: codecs: fix type confusion of list iterator variable
Date:   Mon, 13 Jun 2022 12:08:24 +0200
Message-Id: <20220613094922.952614659@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094922.843438024@linuxfoundation.org>
References: <20220613094922.843438024@linuxfoundation.org>
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
index b589cf6b1d03..e19b91e7a72e 100644
--- a/drivers/staging/greybus/audio_codec.c
+++ b/drivers/staging/greybus/audio_codec.c
@@ -599,8 +599,8 @@ static int gbcodec_mute_stream(struct snd_soc_dai *dai, int mute, int stream)
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



