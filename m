Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C940489197
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:34:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240895AbiAJHdr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:33:47 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40590 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233849AbiAJHbn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:31:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 267E360B9F;
        Mon, 10 Jan 2022 07:31:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0956DC36AEF;
        Mon, 10 Jan 2022 07:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799902;
        bh=lcHfSChScLvyGOU8GsHzTVoEVeZZVhOFXm8cepE1HTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BM0rmaF/mdPSM3kmb9dnLnogb1jsxnnsHkxCrE1WD9ec6hLm9V2Ja1+SZ+pmBzW6C
         tbfZ5Wbs7NhwVQk7oOGUqJPB7zMqG2n1XleTD3iA6+jPvkGvfjsNw2zsMvn+fXKUvn
         rKSr2uiswp9acKkJJR7hE0Az54HjefQM2xhCnRIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 11/72] netrom: fix copying in user data in nr_setsockopt
Date:   Mon, 10 Jan 2022 08:22:48 +0100
Message-Id: <20220110071821.925775387@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071821.500480371@linuxfoundation.org>
References: <20220110071821.500480371@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 3087a6f36ee028ec095c04a8531d7d33899b7fed upstream.

This code used to copy in an unsigned long worth of data before
the sockptr_t conversion, so restore that.

Fixes: a7b75c5a8c41 ("net: pass a sockptr_t into ->setsockopt")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netrom/af_netrom.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -306,7 +306,7 @@ static int nr_setsockopt(struct socket *
 	if (optlen < sizeof(unsigned int))
 		return -EINVAL;
 
-	if (copy_from_sockptr(&opt, optval, sizeof(unsigned int)))
+	if (copy_from_sockptr(&opt, optval, sizeof(unsigned long)))
 		return -EFAULT;
 
 	switch (optname) {


