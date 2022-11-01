Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1A746144A3
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 07:26:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbiKAG0G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 02:26:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbiKAG0E (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 02:26:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9382617403;
        Mon, 31 Oct 2022 23:26:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3027161558;
        Tue,  1 Nov 2022 06:26:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DC19C43470;
        Tue,  1 Nov 2022 06:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667283962;
        bh=OaO+XelnWMW/u0cOBszql70fy6hSA/p5SVGEnpZDtsw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hxCk11tm93WDhrYNQyxSfs/0zRCl5C+Dgaq91uU3tfHilBGq6EMIZnqjT6sFkuLXS
         hIhtATdY7yshgGgUjvVidYOCUaBfX2rSJLiKQ3oyP/Xuo5oD2ZvWvi4H6IN2tKPrgB
         rYctmeS5exXcUjvzT9jh8yxNj9DnQrmZ6gJ1IanU=
Date:   Tue, 1 Nov 2022 07:25:38 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Yongqin Liu <yongqin.liu@linaro.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Eric Dumazet <edumazet@google.com>, Willy Tarreau <w@1wt.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Benjamin Copeland <ben.copeland@linaro.org>,
        Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Subject: Re: [PATCH 4.19 092/229] once: add DO_ONCE_SLOW() for sleepable
 contexts
Message-ID: <Y2C74nuMI3RBroTg@kroah.com>
References: <20221024112959.085534368@linuxfoundation.org>
 <20221024113002.025977656@linuxfoundation.org>
 <CAMSo37XApZ_F5nSQYWFsSqKdMv_gBpfdKG3KN1TDB+QNXqSh0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMSo37XApZ_F5nSQYWFsSqKdMv_gBpfdKG3KN1TDB+QNXqSh0A@mail.gmail.com>
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 01, 2022 at 02:07:35PM +0800, Yongqin Liu wrote:
> Hello,
> 
> As mentioned in the thread for the 5.4 version here[1], it causes a
> crash for the 4.19 kernel too.
> Just paste the log here for reference:

Can you try this patch please:


diff --git a/include/linux/once.h b/include/linux/once.h
index bb58e1c3aa03..3a6671d961b9 100644
--- a/include/linux/once.h
+++ b/include/linux/once.h
@@ -64,7 +64,7 @@ void __do_once_slow_done(bool *done, struct static_key_true *once_key,
 #define DO_ONCE_SLOW(func, ...)						     \
 	({								     \
 		bool ___ret = false;					     \
-		static bool __section(".data.once") ___done = false;	     \
+		static bool __section(.data.once) ___done = false;	     \
 		static DEFINE_STATIC_KEY_TRUE(___once_key);		     \
 		if (static_branch_unlikely(&___once_key)) {		     \
 			___ret = __do_once_slow_start(&___done);	     \
