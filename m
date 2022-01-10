Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA544891E0
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:42:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235572AbiAJHg4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:36:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240994AbiAJHeb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:34:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03C72C0253B4;
        Sun,  9 Jan 2022 23:30:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A31A7B811F5;
        Mon, 10 Jan 2022 07:30:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0E53C36AE9;
        Mon, 10 Jan 2022 07:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799808;
        bh=lcHfSChScLvyGOU8GsHzTVoEVeZZVhOFXm8cepE1HTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xm0bVeDVer+osjw9s9+od5vF4/9ybwm/SQlP4Yx20Hivyc8boEeaKXcPYN4UA3jxx
         J5MdrTLKW4oGaoGWXbvJITcjAd56Jyktb4mEJqsDMP5uhbPRvDuyCACCGUj0cBjK2W
         MbvVjGJvP8xKugFkSe5tpYI3++WzA2DeEkGz/NzA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 09/43] netrom: fix copying in user data in nr_setsockopt
Date:   Mon, 10 Jan 2022 08:23:06 +0100
Message-Id: <20220110071817.669190550@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071817.337619922@linuxfoundation.org>
References: <20220110071817.337619922@linuxfoundation.org>
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


