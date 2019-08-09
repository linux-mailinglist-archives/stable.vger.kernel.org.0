Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4025187C0B
	for <lists+stable@lfdr.de>; Fri,  9 Aug 2019 15:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406886AbfHINqH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Aug 2019 09:46:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:35624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406518AbfHINqH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Aug 2019 09:46:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6DD8217D7;
        Fri,  9 Aug 2019 13:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565358366;
        bh=eLO/e/KA4TzDwacNEE2MlDgRix+GcyiN1TH0oGPTiMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KZAup71aPhHloq96BLsiWIO3gr36c/hec21mq+uJNfAdm0yiOz0hTw6jfF/Ig7FEG
         fylFCbAdB56lfTcxrUL/ekm3zKGX/xSPbwKo95sPhqJtjDXBpJWUH9p0x7lUM7i7Po
         hJxvWbihicG6nlNKogM3IFHnuVm2C6n3Ed4qKfAw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phil Turnbull <phil.turnbull@oracle.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 03/21] netfilter: nfnetlink_acct: validate NFACCT_QUOTA parameter
Date:   Fri,  9 Aug 2019 15:45:07 +0200
Message-Id: <20190809134241.707489370@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809134241.565496442@linuxfoundation.org>
References: <20190809134241.565496442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit eda3fc50daa93b08774a18d51883c5a5d8d85e15 ]

If a quota bit is set in NFACCT_FLAGS but the NFACCT_QUOTA parameter is
missing then a NULL pointer dereference is triggered. CAP_NET_ADMIN is
required to trigger the bug.

Signed-off-by: Phil Turnbull <phil.turnbull@oracle.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nfnetlink_acct.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -97,6 +97,8 @@ nfnl_acct_new(struct sock *nfnl, struct
 			return -EINVAL;
 		if (flags & NFACCT_F_OVERQUOTA)
 			return -EINVAL;
+		if ((flags & NFACCT_F_QUOTA) && !tb[NFACCT_QUOTA])
+			return -EINVAL;
 
 		size += sizeof(u64);
 	}


