Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6E7B1F7D09
	for <lists+stable@lfdr.de>; Fri, 12 Jun 2020 20:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbgFLSm3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jun 2020 14:42:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45718 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbgFLSm3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jun 2020 14:42:29 -0400
Received: from ip5f5af183.dynamic.kabel-deutschland.de ([95.90.241.131] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jjodC-0007Zp-RA; Fri, 12 Jun 2020 18:42:22 +0000
Date:   Fri, 12 Jun 2020 20:42:21 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     Giuseppe Scrivano <gscrivan@redhat.com>,
        Robert Sesek <rsesek@google.com>,
        Chris Palmer <palmer@google.com>, Jann Horn <jannh@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "containers@lists.linux-foundation.org" 
        <containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        Matt Denton <mpdenton@google.com>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v3 1/4] fs, net: Standardize on file_receive helper to
 move fds across processes
Message-ID: <20200612184221.rszwhnhvhnigyazq@wittgenstein>
References: <202006101953.899EFB53@keescook>
 <20200611100114.awdjswsd7fdm2uzr@wittgenstein>
 <20200611110630.GB30103@ircssh-2.c.rugged-nimbus-611.internal>
 <067f494d55c14753a31657f958cb0a6e@AcuMS.aculab.com>
 <202006111634.8237E6A5C6@keescook>
 <94407449bedd4ba58d85446401ff0a42@AcuMS.aculab.com>
 <20200612104629.GA15814@ircssh-2.c.rugged-nimbus-611.internal>
 <202006120806.E770867EF@keescook>
 <20200612182816.okwylihs6u6wkgxd@wittgenstein>
 <202006121135.F04D66DFA@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <202006121135.F04D66DFA@keescook>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 12, 2020 at 11:38:33AM -0700, Kees Cook wrote:
> On Fri, Jun 12, 2020 at 08:28:16PM +0200, Christian Brauner wrote:
> > Al didn't want the PAGE_SIZE limit in there because there's nothing
> > inherently wrong with copying insane amounts of memory.
> 
> Right, ok.
> 
> > (Another tangent. I've asked this on Twitter not too long ago: do we
> > have stats how long copy_from_user()/copy_struct_from_user() takes with
> > growing struct/memory size? I'd be really interested in this. I have a
> > feeling that clone3()'s and - having had a chat with David Howells -
> > openat2()'s structs will continue to grow for a while... and I'd really
> > like to have some numbers on when copy_struct_from_user() becomes
> > costly or how costly it becomes.)
> 
> How long it takes? It should be basically the same, the costs should be
> mostly in switching memory protections, etc. I wouldn't imagine how many
> bytes being copied would matter much here, given the sub-page sizes.

This makes me _very_ happy.

Christian
