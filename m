Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 574146AADD4
	for <lists+stable@lfdr.de>; Sun,  5 Mar 2023 03:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbjCECST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Mar 2023 21:18:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjCECSS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Mar 2023 21:18:18 -0500
Received: from todd.t-8ch.de (todd.t-8ch.de [IPv6:2a01:4f8:c010:41de::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C495EF80;
        Sat,  4 Mar 2023 18:18:17 -0800 (PST)
Date:   Sun, 5 Mar 2023 02:18:11 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
        s=mail; t=1677982694;
        bh=5sfEmY5t1qq4BwNnE7N+61KyzgK3aKNQJDhCA+hG7Aw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fib/hnFw1wXgLgx2WVqNRfwAS/XUGKq7gSgou4W+u6tk7Upxbkwx3CxhAUL53vF5b
         LIqKacta6GrnEgHQ58UcC5skPYLP2LbRuUkMIbrHErQqjRxVCWcrbLcBpuLYCOyYNf
         N3OTVsYaKhfhYnt4kHWu5u8UYW0kzf2IMfjBnIQY=
From:   Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>
To:     stable@vger.kernel.org
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Iurii Zaikin <yzaikin@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Storm Dragon <stormdragon2976@gmail.com>
Subject: Request to backport "sysctl: fix proc_dobool() usability" to stable
 kernels
Message-ID: <9563010d-a5cf-49e2-8c51-f2e66f064997@t-8ch.de>
References: <20230210145823.756906-1-omosnace@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230210145823.756906-1-omosnace@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi -stable team,

please backport the commit f1aa2eb5ea05 ("sysctl: fix proc_dobool() usability")
to the stable kernels containing commit 83efeeeb3d04 ("tty: Allow TIOCSTI to be disabled").
(Which seems only to be the 6.2 branch only at the moment)

Without this backport the sysctl dev.net.legacy_tiocsti to enable
ioctl(TIOCSTI) is not functional. So on kernels that don't enable
CONFIG_LEGACY_TIOCSTI, ioctl(TIOCSTI) is not usable at all.

This ioctl is used for the copy-and-paste functionality of the
screenreader "fenrir".
( https://github.com/chrys87/fenrir )

Reported-by: Storm Dragon <stormdragon2976@gmail.com>
Link: https://lore.kernel.org/lkml/ZAOi9hDBTYqoAZuI@hotmail.com/
