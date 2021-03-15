Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCC5033BA43
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235297AbhCOOIm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:08:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:49418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234128AbhCOOC6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:02:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0974F64EEE;
        Mon, 15 Mar 2021 14:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816978;
        bh=pahPprvgMlC98Q1N7i19LIWDb7xGXm3jUnB5rspMKQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RnmDYhIJYCKZL/jNUY1WM55Ai+mulZLZLmMSP3dBBWspKILzGtQLwxHr6taV6h3b+
         HJJKi4AdFMgTEjGXaYlqeKO8VVf2wrjcGaSILVReTAfWDVc1pbxnuPdFkvZSKiBVyy
         AYNjHAtq4TAkseynAUerv0ZdnKCwoSP9NnlXNMvk=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Jonathan Marek <jonathan@marek.ca>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: [PATCH 5.10 224/290] misc: fastrpc: restrict user apps from sending kernel RPC messages
Date:   Mon, 15 Mar 2021 14:55:17 +0100
Message-Id: <20210315135549.545419195@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

commit 20c40794eb85ea29852d7bc37c55713802a543d6 upstream.

Verify that user applications are not using the kernel RPC message
handle to restrict them from directly attaching to guest OS on the
remote subsystem. This is a port of CVE-2019-2308 fix.

Fixes: c68cfb718c8f ("misc: fastrpc: Add support for context Invoke method")
Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Jonathan Marek <jonathan@marek.ca>
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20210212192658.3476137-1-dmitry.baryshkov@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -948,6 +948,11 @@ static int fastrpc_internal_invoke(struc
 	if (!fl->cctx->rpdev)
 		return -EPIPE;
 
+	if (handle == FASTRPC_INIT_HANDLE && !kernel) {
+		dev_warn_ratelimited(fl->sctx->dev, "user app trying to send a kernel RPC message (%d)\n",  handle);
+		return -EPERM;
+	}
+
 	ctx = fastrpc_context_alloc(fl, kernel, sc, args);
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);


