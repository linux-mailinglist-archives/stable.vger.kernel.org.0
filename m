Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D30A541EB4
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380424AbiFGWdP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:33:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381525AbiFGWb4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:31:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42BDD27C24B;
        Tue,  7 Jun 2022 12:25:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EDF63B823CA;
        Tue,  7 Jun 2022 19:25:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60B49C385A5;
        Tue,  7 Jun 2022 19:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629929;
        bh=4pNNSTUd2ZJDIkV5UTFgoNifM2igfy8EKigtrAPUaF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ovCPK5cGXPj8fXzDf4KWE40Swg46F35CA+8A3FYp9JiXD3B66pgV1fTNcuNuxO69
         p1Xrerk5Afmn18jodO8jn14wU+9LaJWVEE4RyNFGvs/LDao+Fc1n8CEmCBOfPPMggH
         bcFQ+IwkTA4YiPEi7y5TYVZDAj488ttLK+kWmNPk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christopher Ferris <cferris@google.com>,
        Carlos Llamas <cmllamas@google.com>,
        Todd Kjos <tkjos@google.com>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.18 868/879] binder: fix sender_euid type in uapi header
Date:   Tue,  7 Jun 2022 19:06:26 +0200
Message-Id: <20220607165028.048490141@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Carlos Llamas <cmllamas@google.com>

commit 8cc5b032240ae5220b62c689c20459d3e1825b2d upstream.

The {pid,uid}_t fields of struct binder_transaction were recently
replaced to use kernel types in commit 169adc2b6b3c ("android/binder.h:
add linux/android/binder(fs).h to UAPI compile-test coverage").

However, using __kernel_uid_t here breaks backwards compatibility in
architectures using 16-bits for this type, since glibc and some others
still expect a 32-bit uid_t. Instead, let's use __kernel_uid32_t which
avoids this compatibility problem.

Fixes: 169adc2b6b3c ("android/binder.h: add linux/android/binder(fs).h to UAPI compile-test coverage")
Reported-by: Christopher Ferris <cferris@google.com>
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Acked-by: Todd Kjos <tkjos@google.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/android/binder.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/uapi/linux/android/binder.h
+++ b/include/uapi/linux/android/binder.h
@@ -289,7 +289,7 @@ struct binder_transaction_data {
 	/* General information about the transaction. */
 	__u32	        flags;
 	__kernel_pid_t	sender_pid;
-	__kernel_uid_t	sender_euid;
+	__kernel_uid32_t	sender_euid;
 	binder_size_t	data_size;	/* number of bytes of data */
 	binder_size_t	offsets_size;	/* number of bytes of offsets */
 


