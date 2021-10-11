Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12C45428F11
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237813AbhJKNyp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:54:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:40550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237539AbhJKNxP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:53:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 726BB60F38;
        Mon, 11 Oct 2021 13:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960267;
        bh=6HKDCx+ad9b/P5y/PaIadr5JJJ84ChOLIAYP/vJHqtU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lzQVhR/q7qv5io4g/ftjgNuwss2fN85MLU1ls65C1lNgN/T9hlu0doVusMK3H2vWT
         ilFz19MJ4iTL4WSn8gnUSRKf7M1ElXjK/ibBaGDb7Vq1Vnkcc7RwcWL37dZJ0yYtPq
         3YUghghqsXZPHeYXZG53u8jHLl9Qr0Mqv/8O6UGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "J. Bruce Fields" <bfields@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.10 15/83] SUNRPC: fix sign error causing rpcsec_gss drops
Date:   Mon, 11 Oct 2021 15:45:35 +0200
Message-Id: <20211011134508.880524317@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134508.362906295@linuxfoundation.org>
References: <20211011134508.362906295@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: J. Bruce Fields <bfields@redhat.com>

commit 2ba5acfb34957e8a7fe47cd78c77ca88e9cc2b03 upstream.

If sd_max is unsigned, then sd_max - GSS_SEQ_WIN is a very large number
whenever sd_max is less than GSS_SEQ_WIN, and the comparison:

	seq_num <= sd->sd_max - GSS_SEQ_WIN

in gss_check_seq_num is pretty much always true, even when that's
clearly not what was intended.

This was causing pynfs to hang when using krb5, because pynfs uses zero
as the initial gss sequence number.  That's perfectly legal, but this
logic error causes knfsd to drop the rpc in that case.  Out-of-order
sequence IDs in the first GSS_SEQ_WIN (128) calls will also cause this.

Fixes: 10b9d99a3dbb ("SUNRPC: Augment server-side rpcgss tracepoints")
Cc: stable@vger.kernel.org
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/auth_gss/svcauth_gss.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -643,7 +643,7 @@ static bool gss_check_seq_num(const stru
 		}
 		__set_bit(seq_num % GSS_SEQ_WIN, sd->sd_win);
 		goto ok;
-	} else if (seq_num <= sd->sd_max - GSS_SEQ_WIN) {
+	} else if (seq_num + GSS_SEQ_WIN <= sd->sd_max) {
 		goto toolow;
 	}
 	if (__test_and_set_bit(seq_num % GSS_SEQ_WIN, sd->sd_win))


