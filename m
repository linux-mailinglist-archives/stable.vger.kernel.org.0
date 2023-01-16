Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8F9966C49B
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbjAPP4r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:56:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231717AbjAPP4R (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:56:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79D5F1BAF8
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:56:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 318B4B81059
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:56:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A6D4C433D2;
        Mon, 16 Jan 2023 15:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884573;
        bh=OxfDhpjLL4D/Qn2aX4GOaB17ssJo05peJuHl7MCXS6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1z7p387W3go2xKo3ia9+PrDTw23hQzzllHTiON4vpNfSjrl7q7LvcjOrZ8EL/szwn
         j74SbnYL/zmCPuvBKqkVno+ugQS94gXhBsqy4j1wpGW7PKAGPWs+/4/W8+jd5YiCzi
         DpW6SEVO/26Ns0QKdTPT/JCsHlwhsg5cX6BZ2qjE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mark Brown <broonie@kernel.org>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 6.1 057/183] arm64/signal: Always allocate SVE signal frames on SME only systems
Date:   Mon, 16 Jan 2023 16:49:40 +0100
Message-Id: <20230116154805.757247441@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Brown <broonie@kernel.org>

commit f26cd7372160da2eba31061d7943348ab9f2c01d upstream.

Currently we only allocate space for SVE signal frames on systems that
support SVE, meaning that SME only systems do not allocate a signal frame
for streaming mode SVE state. Change the check so space is allocated if
either feature is supported.

Fixes: 85ed24dad290 ("arm64/sme: Implement streaming SVE signal handling")
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20221223-arm64-fix-sme-only-v1-3-938d663f69e5@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/signal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -729,7 +729,7 @@ static int setup_sigframe_layout(struct
 			return err;
 	}
 
-	if (system_supports_sve()) {
+	if (system_supports_sve() || system_supports_sme()) {
 		unsigned int vq = 0;
 
 		if (add_all || test_thread_flag(TIF_SVE) ||


