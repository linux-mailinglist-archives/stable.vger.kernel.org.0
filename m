Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1518D4890E2
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:28:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239317AbiAJH0g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:26:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239423AbiAJHZf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:25:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 676A8C034006;
        Sun,  9 Jan 2022 23:25:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11F20B81202;
        Mon, 10 Jan 2022 07:25:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59F0DC36AE9;
        Mon, 10 Jan 2022 07:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799503;
        bh=pcw/Sg/w0E9cf2w+sEgUp/zOjqIvw3IKwr7bxLEonhY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X6Tch0qEkfxq0oF/x1IIXdQPP5p1kCa0EgVtNYckeRfeZIDvOa583WQtQLJ4UAbAW
         oAbh3DtNHzNZWlx+JJvAiiNeZzA11l/MWcNtg4G/siUw8bjJHmdFD/5pEhfxJXbhnW
         yJD3marqVyGaX+C/ElQO32GeI3fM3QAF1K63WSiI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Aayush Agarwal <aayush.a.agarwal@oracle.com>
Subject: [PATCH 4.9 16/21] phonet: refcount leak in pep_sock_accep
Date:   Mon, 10 Jan 2022 08:23:03 +0100
Message-Id: <20220110071813.352874376@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071812.806606886@linuxfoundation.org>
References: <20220110071812.806606886@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangyu Hua <hbh25y@gmail.com>

commit bcd0f93353326954817a4f9fa55ec57fb38acbb0 upstream.

sock_hold(sk) is invoked in pep_sock_accept(), but __sock_put(sk) is not
invoked in subsequent failure branches(pep_accept_conn() != 0).

Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Link: https://lore.kernel.org/r/20211209082839.33985-1-hbh25y@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Aayush Agarwal <aayush.a.agarwal@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/phonet/pep.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/phonet/pep.c
+++ b/net/phonet/pep.c
@@ -878,6 +878,7 @@ static struct sock *pep_sock_accept(stru
 
 	err = pep_accept_conn(newsk, skb);
 	if (err) {
+		__sock_put(sk);
 		sock_put(newsk);
 		newsk = NULL;
 		goto drop;


