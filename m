Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 138D85406D2
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347217AbiFGRiw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347231AbiFGRhi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:37:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A33671929F;
        Tue,  7 Jun 2022 10:33:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B868A6146F;
        Tue,  7 Jun 2022 17:33:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA505C385A5;
        Tue,  7 Jun 2022 17:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623189;
        bh=lvjgWwCWMMG4oPUt5XqFiKHL2VFjfq8Xa8zNktZpPmc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZSHoxsOwvD5kDiLv/cTblZnngxsW/IVrXK5GHgpkbMX5C0Uj/Oak5Zsv770LrKCGa
         a5QrAFik7Wl42J29nnZNa0HQb84tfuC0ytpZxq/1IAa8sGxMpR67VtCYmiKMCUjZXg
         kO4CSMRo4F+EHJEyUuYXH+RcVfQ6z10Uy8RDspYk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 326/452] i2c: at91: Initialize dma_buf in at91_twi_xfer()
Date:   Tue,  7 Jun 2022 19:03:03 +0200
Message-Id: <20220607164918.275566049@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
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

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 6977262c2eee111645668fe9e235ef2f5694abf7 ]

Clang warns:

  drivers/i2c/busses/i2c-at91-master.c:707:6: warning: variable 'dma_buf' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
          if (dev->use_dma) {
              ^~~~~~~~~~~~
  drivers/i2c/busses/i2c-at91-master.c:717:27: note: uninitialized use occurs here
          i2c_put_dma_safe_msg_buf(dma_buf, m_start, !ret);
                                   ^~~~~~~

Initialize dma_buf to NULL, as i2c_put_dma_safe_msg_buf() is a no-op
when the first argument is NULL, which will work for the !dev->use_dma
case.

Fixes: 03fbb903c8bf ("i2c: at91: use dma safe buffers")
Link: https://github.com/ClangBuiltLinux/linux/issues/1629
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Michael Walle <michael@walle.cc>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-at91-master.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-at91-master.c b/drivers/i2c/busses/i2c-at91-master.c
index 974225faaf96..7960fa4b8c5b 100644
--- a/drivers/i2c/busses/i2c-at91-master.c
+++ b/drivers/i2c/busses/i2c-at91-master.c
@@ -657,7 +657,7 @@ static int at91_twi_xfer(struct i2c_adapter *adap, struct i2c_msg *msg, int num)
 	unsigned int_addr_flag = 0;
 	struct i2c_msg *m_start = msg;
 	bool is_read;
-	u8 *dma_buf;
+	u8 *dma_buf = NULL;
 
 	dev_dbg(&adap->dev, "at91_xfer: processing %d messages:\n", num);
 
-- 
2.35.1



