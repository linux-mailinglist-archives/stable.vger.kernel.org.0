Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD23D4BB4CD
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 10:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233009AbiBRJB5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 04:01:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233000AbiBRJB4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 04:01:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7110E51331;
        Fri, 18 Feb 2022 01:01:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 330FFB825AE;
        Fri, 18 Feb 2022 09:01:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5989DC340E9;
        Fri, 18 Feb 2022 09:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645174898;
        bh=xVrAIrahrueaW9ffryAhmcNWxZJXZm/2LO+7/0W/VI4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FL1t7Ns7A9wwzcfynYdLqp6eEE/kIcInmdRwHMHElX0Nz2PKz7Ae5s3Q1mAm4cDjD
         gavbfz53KfYdOU3bzajaAbZKubcC0Y+RXatjm1k2CRIJs5lkNtOz1Q4uQRPy/oB9Ay
         +RWkY0Tcz+Op0N3UKrcUCSMK7CZKrd2pn2yTIij4=
Date:   Fri, 18 Feb 2022 10:01:35 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Stephen Boyd <swboyd@chromium.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Sami Tolvanen <samitolvanen@google.com>
Subject: Re: arm64 ftrace fixes for v5.4.y
Message-ID: <Yg9gb4qXyPVyE60W@kroah.com>
References: <CAE-0n53cOFJFOOV-YOc0MzbiLr9FvaJw=ucs2SNNGOeznYzVLw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE-0n53cOFJFOOV-YOc0MzbiLr9FvaJw=ucs2SNNGOeznYzVLw@mail.gmail.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 17, 2022 at 05:27:33PM -0800, Stephen Boyd wrote:
> Hi stable maintainers,
> 
> I recently ran into an issue where trying to load a module with jump
> table entries crashes the system when function tracing is enabled. The
> crash happens because ftrace is modifying the code and then marking it
> as read-only too early. ftrace_make_call() calls module_enable_ro(mod,
> true) before module init is over because ftrace_module_enable() calls
> __ftrace_replace_code() which does FTRACE_UPDATE_MAKE_CALL. All this
> code is gone now upstream but is still present on v5.4 stable kernels. I
> picked this set of patches to v5.4 and it fixed it for me.
> 
> fbf6c73c5b26 ftrace: add ftrace_init_nop()
> a1326b17ac03 module/ftrace: handle patchable-function-entry
> bd8b21d3dd66 arm64: module: rework special section handling
> f1a54ae9af0d arm64: module/ftrace: intialize PLT at load time

These all apply just fine, thanks.

> after doing that I ran into another issue because I'm using clang. Would
> it be possible to pick two more patches to the stable tree to silence
> this module warning from sysfs complaining about
> /module/<modname>/sections/__patchable_function_entries being
> duplicated?
> 
> dd2776222abb kbuild: lto: merge module sections
> 6a3193cdd5e5 kbuild: lto: Merge module sections if and only if
> CONFIG_LTO_CLANG is enabled

These two do not apply to the 5.4.y branch, as the file they touch is
not present in 5.4.y.  They do apply to 5.10.y, so I've queued them up
there, but I think you need to provide a working backport please.

thanks,

greg k-h
