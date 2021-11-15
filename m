Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D647450C5B
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238251AbhKORhq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:37:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:47378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238320AbhKORe3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:34:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EC11632BE;
        Mon, 15 Nov 2021 17:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996986;
        bh=Y+1v+vmRwq3BOqP286Wh0XGSek2SDO34d9ypQfS1trs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aZz841jzGainu+YVuHi8JCacZHGHcTLQ6X5ik3pSDkSB8gkLaCjxnWpAbvrMg+YdZ
         +XaeuKYmMKOSDGBTGQ3fzBCqsIggnFH1vablP+4Anne/E/1oRN3EeSBo+36QPqrbeP
         KGWGd8s/6cM8uwYSkE0WZCbxdiPR+H1bQHGDYbM4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+06472778c97ed94af66d@syzkaller.appspotmail.com,
        Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH 5.4 340/355] 9p/net: fix missing error check in p9_check_errors
Date:   Mon, 15 Nov 2021 18:04:24 +0100
Message-Id: <20211115165324.739164331@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
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
@@ -538,6 +538,8 @@ static int p9_check_errors(struct p9_cli
 		kfree(ename);
 	} else {
 		err = p9pdu_readf(&req->rc, c->proto_version, "d", &ecode);
+		if (err)
+			goto out_err;
 		err = -ecode;
 
 		p9_debug(P9_DEBUG_9P, "<<< RLERROR (%d)\n", -ecode);


