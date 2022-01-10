Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B43BB4891EE
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240187AbiAJHhO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:37:14 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36500 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240341AbiAJHac (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:30:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94639611EC;
        Mon, 10 Jan 2022 07:30:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78928C36AFF;
        Mon, 10 Jan 2022 07:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799831;
        bh=3Ickka+6v+gJYj2pcGsavEYdwSot3ss+0+8d/9R7JoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nFTfKCCSgg9k2MbP38pnfsdq047G6yLJe5enh3IGBOt9YA/ngVbv3q0YkvL3R1ms+
         UHcPa8Io2LnaX1oMSTEgJK+T0v0vL6ek0piw/b/L+jI/ZDL7erlO5yHbMk/aDdGOH+
         0ah7L2n9b2DEhlfJTVsvjo1uHGEhSi8/gdLpKL6o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Aayush Agarwal <aayush.a.agarwal@oracle.com>
Subject: [PATCH 5.10 30/43] phonet: refcount leak in pep_sock_accep
Date:   Mon, 10 Jan 2022 08:23:27 +0100
Message-Id: <20220110071818.355783033@linuxfoundation.org>
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
@@ -868,6 +868,7 @@ static struct sock *pep_sock_accept(stru
 
 	err = pep_accept_conn(newsk, skb);
 	if (err) {
+		__sock_put(sk);
 		sock_put(newsk);
 		newsk = NULL;
 		goto drop;


