Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37B025217C5
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241117AbiEJN2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243898AbiEJN1f (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:27:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AAE92C182B;
        Tue, 10 May 2022 06:20:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C5EDB81CF8;
        Tue, 10 May 2022 13:20:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9276C385C2;
        Tue, 10 May 2022 13:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188842;
        bh=uWNfTbyVD20wguGhW1RfOtpw8PG/VpQ0yqM5YEg8S1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YX+Bg6y0QSCZcQ62oORtesNgHwqaCTCQeIvbAf+yddqdc4bYfLD/MDszME8d4AjrQ
         G5B+tvZByLqhdmytEwkHaP7ptLuz9BKAQK7Fo4Jog8exH5f21lN2PGc4kDYYMlMwwU
         lUux9pGUprTh+EJlya7WDX3kvoEikQao4ZKFElz4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "wanghai (M)" <wanghai38@huawei.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 4.19 62/88] Revert "SUNRPC: attempt AF_LOCAL connect on setup"
Date:   Tue, 10 May 2022 15:07:47 +0200
Message-Id: <20220510130735.542425319@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130733.735278074@linuxfoundation.org>
References: <20220510130733.735278074@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit a3d0562d4dc039bca39445e1cddde7951662e17d upstream.

This reverts commit 7073ea8799a8cf73db60270986f14e4aae20fa80.

We must not try to connect the socket while the transport is under
construction, because the mechanisms to safely tear it down are not in
place. As the code stands, we end up leaking the sockets on a connection
error.

Reported-by: wanghai (M) <wanghai38@huawei.com>
Cc: stable@vger.kernel.org
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/xprtsock.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -2974,9 +2974,6 @@ static struct rpc_xprt *xs_setup_local(s
 		}
 		xprt_set_bound(xprt);
 		xs_format_peer_addresses(xprt, "local", RPCBIND_NETID_LOCAL);
-		ret = ERR_PTR(xs_local_setup_socket(transport));
-		if (ret)
-			goto out_err;
 		break;
 	default:
 		ret = ERR_PTR(-EAFNOSUPPORT);


