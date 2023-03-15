Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6192B6BB063
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:17:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231912AbjCOMRv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231961AbjCOMRp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:17:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 133F9907BE
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:17:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B694EB81E01
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:17:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DE30C433EF;
        Wed, 15 Mar 2023 12:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882654;
        bh=YUxyZHl5bRB0BwmAop66aFY1XoWuGvc+sje5RqZZRng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lXVA8D1eQ1NKJ1OXJde+2EvUuSy85CS/UlMDrCzHhfdDHI2LDmkFcK26BQRI/sDiO
         xPz394LKZ7Qz05xbr+u0ICD04hZgXSA8OtH4Jz9KRu1GMrYdT439pgS49B4VpZyjhX
         oGQrr9cIkU5o2TOg+Fw0puYB7VoB2/9J/oAguJsk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Corey Minyard <cminyard@mvista.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 20/68] ipmi:ssif: Increase the message retry time
Date:   Wed, 15 Mar 2023 13:12:14 +0100
Message-Id: <20230315115726.892015865@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115726.103942885@linuxfoundation.org>
References: <20230315115726.103942885@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Corey Minyard <cminyard@mvista.com>

[ Upstream commit 39721d62bbc16ebc9bb2bdc2c163658f33da3b0b ]

The spec states that the minimum message retry time is 60ms, but it was
set to 20ms.  Correct it.

Reported by: Tony Camuso <tcamuso@redhat.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Stable-dep-of: 00bb7e763ec9 ("ipmi:ssif: Add a timer between request retries")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ipmi_ssif.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/ipmi/ipmi_ssif.c b/drivers/char/ipmi/ipmi_ssif.c
index 9f1fb8a30a823..02ca0d9a0d8cb 100644
--- a/drivers/char/ipmi/ipmi_ssif.c
+++ b/drivers/char/ipmi/ipmi_ssif.c
@@ -79,7 +79,7 @@
 /*
  * Timer values
  */
-#define SSIF_MSG_USEC		20000	/* 20ms between message tries. */
+#define SSIF_MSG_USEC		60000	/* 60ms between message tries. */
 #define SSIF_MSG_PART_USEC	5000	/* 5ms for a message part */
 
 /* How many times to we retry sending/receiving the message. */
-- 
2.39.2



