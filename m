Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD2506AFEC6
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 07:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbjCHGNz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 01:13:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbjCHGNy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 01:13:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC25291B71
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 22:13:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D387FB81BBF
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 06:13:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A32BC433D2;
        Wed,  8 Mar 2023 06:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678256027;
        bh=VFSA4CazKPPfy+2mUR37dxz+/RXovPwLWI+9EBomOfg=;
        h=Date:From:To:Cc:Subject:From;
        b=jtZpR9tEgSOIiuISos0WSmn2g3qfTGLBCs/j6LVjaLrA0qSvVzzRC3tH9DC4qu9Az
         /Iq8uSY+OT3VBEINoFoVMrblGMpkGCbULg6ZTj6FZjo8IHHILO+4BreSgqm2VJL0T8
         soinF2edHWf7YVarSnaW7nrFwHyr9n3VkbunYy93KQoIVgkyDyEsJ6l+T7+HpdmM7Z
         SEnd4vKw+K0+8ezIM5jSbkdPvxXLllKQJq6JcutwTVrEl2SBEHT2lPN3VK3hSzb5u+
         sSszAe1kdbaz40jaMLsJgzbCbCZFdk/NA22y26HzKinIuUBQfS54b2L0a+aQQuX/X0
         NBKV/szjB2Jmg==
Date:   Tue, 7 Mar 2023 22:13:45 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     bug-make@gnu.org
Cc:     stable@vger.kernel.org, Dmitry Goncharov <dgoncharov@users.sf.net>
Subject: No progress output when make 4.4.1 builds Linux 4.19 and earlier
Message-ID: <ZAgnmbYtGa80L731@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

After upgrading to make v4.4.1 (released last week), there's no longer any
progress output from builds of the Linux kernel v4.19 and earlier.  It seems the
actual build still works, but it's now silent except for warnings and errors.

It bisects to the following 'make' commit:

    commit dc2d963989b96161472b2cd38cef5d1f4851ea34
    Author: Dmitry Goncharov <dgoncharov@users.sf.net>
    Date:   Sun Nov 27 14:09:17 2022 -0500

        [SV 63347] Always add command line variable assignments to MAKEFLAGS

Is this an intentional breakage from the 'make' side?

- Eric
