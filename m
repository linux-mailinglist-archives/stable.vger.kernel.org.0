Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7251259D9E8
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351906AbiHWKDt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:03:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352403AbiHWKBw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:01:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494797C1BB;
        Tue, 23 Aug 2022 01:49:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D94B6122F;
        Tue, 23 Aug 2022 08:49:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FD22C433D6;
        Tue, 23 Aug 2022 08:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244571;
        bh=P8ClimO+H2U7s8xsr2RV/hjyQfg0HAP3IMy45wBgbco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tR1RJ91txZbFW88UejkmoRlVF4zgXgwtBf6z1k+PmRC4KoSE8ziBBMv6HoEEXbNoE
         jhxhbyrYckji7LrNlEmCgYYavUuUiy5TvOhwLb/0HIfu4VUQ8Y/b+RZPfUCXPjnzZ7
         8m90YFWsQBoa1FdQ1/1XVolnqOcdEejN2g1Fypsg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 5.15 113/244] nios2: restarts apply only to the first sigframe we build...
Date:   Tue, 23 Aug 2022 10:24:32 +0200
Message-Id: <20220823080102.794073051@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit 411a76b7219555c55867466c82d70ce928d6c9e1 upstream.

Fixes: b53e906d255d ("nios2: Signal handling support")
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/nios2/kernel/signal.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/nios2/kernel/signal.c
+++ b/arch/nios2/kernel/signal.c
@@ -264,6 +264,7 @@ static int do_signal(struct pt_regs *reg
 			regs->ea = restart_addr;
 			break;
 		}
+		regs->orig_r2 = -1;
 	}
 
 	if (get_signal(&ksig)) {


