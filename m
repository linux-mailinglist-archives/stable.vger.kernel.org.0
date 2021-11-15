Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54676451E7C
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:33:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245219AbhKPAgQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:36:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:45392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344977AbhKOTZw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F9F9636F7;
        Mon, 15 Nov 2021 19:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003279;
        bh=Fm1GaOwNc/Btx/latzOdwlW0npqN7lWg2ANQjKdp/pY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j3vaNINZpn1Cdj9Uqtjd8JyUXk4vFgQ+fq/42DBBAaN43mvX9JBRYo9ipYnDAuTFg
         yVP+arL067zyZXA16JCTawNf+Ea1RTV5xk/lMMH+yhQFFKQ4LXC/bJtLDdko9VXWvF
         BpN0pvC/fnmZF8a5EvSYFWLJE26fXaOYGtKZZQNw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+06472778c97ed94af66d@syzkaller.appspotmail.com,
        Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH 5.15 875/917] 9p/net: fix missing error check in p9_check_errors
Date:   Mon, 15 Nov 2021 18:06:10 +0100
Message-Id: <20211115165458.721407878@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dominique Martinet <asmadeus@codewreck.org>

commit 27eb4c3144f7a5ebef3c9a261d80cb3e1fa784dc upstream.

Link: https://lkml.kernel.org/r/99338965-d36c-886e-cd0e-1d8fff2b4746@gmail.com
Reported-by: syzbot+06472778c97ed94af66d@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/9p/client.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -541,6 +541,8 @@ static int p9_check_errors(struct p9_cli
 		kfree(ename);
 	} else {
 		err = p9pdu_readf(&req->rc, c->proto_version, "d", &ecode);
+		if (err)
+			goto out_err;
 		err = -ecode;
 
 		p9_debug(P9_DEBUG_9P, "<<< RLERROR (%d)\n", -ecode);


