Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC0142106A
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238098AbhJDNn5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:43:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:51850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238289AbhJDNl7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:41:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF1D161B52;
        Mon,  4 Oct 2021 13:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353553;
        bh=IzX+7kyTjOmmo3IZvMRuxS+FxjknT4JV4igwfZ8qs3c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EFLzgJFeeF+P2W1HHXeLoqYlD9gDShCKuhQWLcPDoagSImgiwoOjUIXhF0k05hZlr
         9FXaR48uQknio6ifPsipHrnUFBvguYirQ4Rx1PYVUHSWP8S5ERX++yg6VVbmlzdk58
         M1s19T45fsxhhqOZfrkJA2kyx74LFNOidZ2MqN+k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+20191dc583eff8602d2d@syzkaller.appspotmail.com,
        Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.14 167/172] crypto: aesni - xts_crypt() return if walk.nbytes is 0
Date:   Mon,  4 Oct 2021 14:53:37 +0200
Message-Id: <20211004125050.365000165@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>

commit 72ff2bf04db2a48840df93a461b7115900f46c05 upstream.

xts_crypt() code doesn't call kernel_fpu_end() after calling
kernel_fpu_begin() if walk.nbytes is 0. The correct behavior should be
not calling kernel_fpu_begin() if walk.nbytes is 0.

Reported-by: syzbot+20191dc583eff8602d2d@syzkaller.appspotmail.com
Signed-off-by: Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/crypto/aesni-intel_glue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -849,7 +849,7 @@ static int xts_crypt(struct skcipher_req
 		return -EINVAL;
 
 	err = skcipher_walk_virt(&walk, req, false);
-	if (err)
+	if (!walk.nbytes)
 		return err;
 
 	if (unlikely(tail > 0 && walk.nbytes < walk.total)) {


