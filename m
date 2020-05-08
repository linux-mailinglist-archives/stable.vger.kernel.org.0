Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF631CABC6
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729487AbgEHMqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:46:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:48642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728880AbgEHMqv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:46:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3FAD2145D;
        Fri,  8 May 2020 12:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942011;
        bh=ZivkGTBaGUqhzvYxAvU+KLi5kFmeSjgp3JYHkZDZZOA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EPntf+yKxi2sMxsSQid/zQkMNvcupj6jSVqij4wg2mPHr/uO6dSbmnWINhngbJcgD
         slQv5VttvedhTtmQDfUHbYyepQkut6v7eBi6UEelRf1z9lOH5Ak0+qIY/9OvBHU0/S
         G9NHJYa3NkAJXR2kif0I4eR+fRZPzgeZbAYtLJzg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Benc <jbenc@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 260/312] cxgbi: fix uninitialized flowi6
Date:   Fri,  8 May 2020 14:34:11 +0200
Message-Id: <20200508123142.709119387@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Benc <jbenc@redhat.com>

commit 3d6d30d60abb19ba9a20e53ce65b18a9c148fcd1 upstream.

ip6_route_output looks into different fields in the passed flowi6 structure,
yet cxgbi passes garbage in nearly all those fields. Zero the structure out
first.

Fixes: fc8d0590d9142 ("libcxgbi: Add ipv6 api to driver")
Signed-off-by: Jiri Benc <jbenc@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/cxgbi/libcxgbi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -692,6 +692,7 @@ static struct rt6_info *find_route_ipv6(
 {
 	struct flowi6 fl;
 
+	memset(&fl, 0, sizeof(fl));
 	if (saddr)
 		memcpy(&fl.saddr, saddr, sizeof(struct in6_addr));
 	if (daddr)


