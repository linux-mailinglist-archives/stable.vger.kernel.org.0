Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 224E3558264
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbiFWRNx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:13:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233394AbiFWRMs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:12:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 470724EDF0;
        Thu, 23 Jun 2022 09:58:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 256686159B;
        Thu, 23 Jun 2022 16:58:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E26A9C36AE2;
        Thu, 23 Jun 2022 16:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003525;
        bh=LvSXorcf4yO/v5ARjHDikb+sJXhPDzAvBgn1B7wUuG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g2HcYMLdeEwKeRAMHxodVawj+M3wunsEUguw1Esrv2g0CZV/WsZ7hJ6ZXOsZQERZD
         dqEtXGANssSxZwstucNC3u/SelWkm+rGrGN3/RJ7VrkfM00OT7mNgAkVdWg4ON/iMd
         em2xw/Q8ZU5+8RSQfTMWJuUY02ab4ZIMvgSG6HeE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Moshe Kol <moshe.kol@mail.huji.ac.il>,
        Yossi Gilad <yossi.gilad@mail.huji.ac.il>,
        Amit Klein <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>, Willy Tarreau <w@1wt.eu>,
        Jakub Kicinski <kuba@kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 260/264] tcp: use different parts of the port_offset for index and offset
Date:   Thu, 23 Jun 2022 18:44:13 +0200
Message-Id: <20220623164351.421561769@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164344.053938039@linuxfoundation.org>
References: <20220623164344.053938039@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willy Tarreau <w@1wt.eu>

commit 9e9b70ae923baf2b5e8a0ea4fd0c8451801ac526 upstream.

Amit Klein suggests that we use different parts of port_offset for the
table's index and the port offset so that there is no direct relation
between them.

Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Moshe Kol <moshe.kol@mail.huji.ac.il>
Cc: Yossi Gilad <yossi.gilad@mail.huji.ac.il>
Cc: Amit Klein <aksecurity@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/inet_hashtables.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -589,7 +589,7 @@ int __inet_hash_connect(struct inet_time
 	net_get_random_once(table_perturb, sizeof(table_perturb));
 	index = hash_32(port_offset, INET_TABLE_PERTURB_SHIFT);
 
-	offset = READ_ONCE(table_perturb[index]) + port_offset;
+	offset = READ_ONCE(table_perturb[index]) + (port_offset >> 32);
 	offset %= remaining;
 
 	/* In first pass we try ports of @low parity.


