Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6F864E7657
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 16:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359837AbiCYPMg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 11:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359857AbiCYPMC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 11:12:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BD7662A2F;
        Fri, 25 Mar 2022 08:09:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D57B7B82904;
        Fri, 25 Mar 2022 15:08:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23280C340F4;
        Fri, 25 Mar 2022 15:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648220926;
        bh=bLyHvRHuwpHkVvuattikF0PH4TZTbUXMmVmmup3vp7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c/qUIwmzbcEDQLlpZ4Nm+diQd+jGIEoqRFYNK8zzZZD21jAJviDBy2tIsumPdYWrU
         Ktv6PIj4cpw66QZgPQ0uXSi4SVj4UMt3kH3UDtKn5XDa8nRO3G6Q8m6PbjDxcEIcoD
         q1bRqJZV6tjowZtSj00E8EGRHUvvC9V3WLJakW1E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.4 28/29] tpm: use try_get_ops() in tpm-space.c
Date:   Fri, 25 Mar 2022 16:05:08 +0100
Message-Id: <20220325150419.395229464@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220325150418.585286754@linuxfoundation.org>
References: <20220325150418.585286754@linuxfoundation.org>
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

From: James Bottomley <James.Bottomley@HansenPartnership.com>

commit fb5abce6b2bb5cb3d628aaa63fa821da8c4600f9 upstream.

As part of the series conversion to remove nested TPM operations:

https://lore.kernel.org/all/20190205224723.19671-1-jarkko.sakkinen@linux.intel.com/

exposure of the chip->tpm_mutex was removed from much of the upper
level code.  In this conversion, tpm2_del_space() was missed.  This
didn't matter much because it's usually called closely after a
converted operation, so there's only a very tiny race window where the
chip can be removed before the space flushing is done which causes a
NULL deref on the mutex.  However, there are reports of this window
being hit in practice, so fix this by converting tpm2_del_space() to
use tpm_try_get_ops(), which performs all the teardown checks before
acquring the mutex.

Cc: stable@vger.kernel.org # 5.4.x
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm2-space.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/char/tpm/tpm2-space.c
+++ b/drivers/char/tpm/tpm2-space.c
@@ -58,12 +58,12 @@ int tpm2_init_space(struct tpm_space *sp
 
 void tpm2_del_space(struct tpm_chip *chip, struct tpm_space *space)
 {
-	mutex_lock(&chip->tpm_mutex);
-	if (!tpm_chip_start(chip)) {
+
+	if (tpm_try_get_ops(chip) == 0) {
 		tpm2_flush_sessions(chip, space);
-		tpm_chip_stop(chip);
+		tpm_put_ops(chip);
 	}
-	mutex_unlock(&chip->tpm_mutex);
+
 	kfree(space->context_buf);
 	kfree(space->session_buf);
 }


