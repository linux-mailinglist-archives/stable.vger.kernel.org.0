Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A21004A4CDC
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 18:14:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380791AbiAaRNx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 12:13:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380790AbiAaRNx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 12:13:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F0BC061714;
        Mon, 31 Jan 2022 09:13:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 603CDB82B94;
        Mon, 31 Jan 2022 17:13:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BB62C340E8;
        Mon, 31 Jan 2022 17:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643649230;
        bh=QKbhQb3UR1s6+IgkObzqyN3XT/7OqGbzgTX3Keth7eU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GuIJTFxO4zIqV3Ue8ez89NoOPQonTyZdASpGL7OeQhz0tgABjROgoYmD+xU4qYCGg
         wLupSkWO7cLALEoh7n5XvVAPb5YWadFTYuYuV48XYJtV5Kf7tsTKXHwgYKaeiJaD2B
         /z+mTlSvVU/154uBGS8Y3UrfLAtMc60HvnrTsDGZGN/h0bFvPN15VdsZmCWaztUG6U
         p64MjOHVX1wWhJicWMsjPH4NA1pXt0/5pn2d1vAHZs9KXntwZqGqa8uzNyrhOTchVo
         RhlXwSaux/U0LJoS/dAs2UlR/gtDGR8nTfpsb7Jwspip6WYCbkssxEmv0aVksj/l2E
         T/gD2LdV1kXlA==
Date:   Mon, 31 Jan 2022 18:13:44 +0100
From:   Christian Brauner <brauner@kernel.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     kernel test robot <oliver.sang@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Ariadne Conill <ariadne@dereferenced.org>,
        0day robot <lkp@intel.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Rich Felker <dalias@libc.org>,
        Eric Biederman <ebiederm@xmission.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, lkp@lists.01.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org
Subject: Re: [fs/exec]  80bd5afdd8: xfstests.generic.633.fail
Message-ID: <20220131171344.77iifun5wdilbqdz@wittgenstein>
References: <20220127000724.15106-1-ariadne@dereferenced.org>
 <20220131144352.GE16385@xsang-OptiPlex-9020>
 <20220131150819.iuqlz3rz6q7cheap@wittgenstein>
 <Yff9+tIDAvYM5EO/@casper.infradead.org>
 <20220131153707.oe45h7tuci2cbfuv@wittgenstein>
 <YfgFeWbZPl+gAUYE@casper.infradead.org>
 <20220131161415.wlvtsd4ecehyg3x5@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220131161415.wlvtsd4ecehyg3x5@wittgenstein>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 31, 2022 at 05:14:15PM +0100, Christian Brauner wrote:
> On Mon, Jan 31, 2022 at 03:51:21PM +0000, Matthew Wilcox wrote:
> > On Mon, Jan 31, 2022 at 04:37:07PM +0100, Christian Brauner wrote:
> > > On Mon, Jan 31, 2022 at 03:19:22PM +0000, Matthew Wilcox wrote:
> > > > On Mon, Jan 31, 2022 at 04:08:19PM +0100, Christian Brauner wrote:
> > > > > On Mon, Jan 31, 2022 at 10:43:52PM +0800, kernel test robot wrote:
> > > > > I can fix this rather simply in our upstream fstests with:
> > > > > 
> > > > > static char *argv[] = {
> > > > > 	"",
> > > > > };
> > > > > 
> > > > > I guess.
> > > > > 
> > > > > But doesn't
> > > > > 
> > > > > static char *argv[] = {
> > > > > 	NULL,
> > > > > };
> > > > > 
> > > > > seem something that should work especially with execveat()?
> > > > 
> > > > The problem is that the exec'ed program sees an argc of 0, which is the
> > > > problem we're trying to work around in the kernel (instead of leaving
> > > > it to ld.so to fix for suid programs).
> > > 
> > > Ok, just seems a bit more intuitive for path-based exec than for
> > > fd-based execveat().
> > > 
> > > What's argv[0] supposed to contain in these cases?
> > > 
> > > 1. execveat(fd, NULL, ..., AT_EMPTY_PATH)
> > > 2. execveat(fd, "my-file", ..., )
> > > 
> > > "" in both 1. and 2.?
> > > "" in 1. and "my-file" in 2.?
> > 
> > You didn't specify argv for either of those, so I have no idea.
> > Programs shouldn't be assuming anything about argv[0]; it's purely
> > advisory.  Unfortunately, some of them do.  And some of them are suid.
> 
> Yes, programs shouldn't assume anything about argv[0]. But a lot of
> programs are used to setting argv[0] to the name of the executed binary.
> The exec* manpages examples do this. Just looking at a random selftest, e.g.
> 
> bpf/prog_tests/test_lsm.c
> 
> where we find:
> 
> 	char *CMD_ARGS[] = {"true", NULL};
> 	execvp(CMD_ARGS[0], CMD_ARGS);
> 
> I'm just wondering how common this is for execveat() because it is not
> as clear what the actual name of the binary is in these two examples
> 
> 	1.
> 	fd = open("/bin/true", );
> 	char *CMD_ARGS[] = {"", NULL};
> 	execveat(fd, NULL, ..., AT_EMPTY_PATH)
> 	
> 	2.
> 	fd = open("/bin", );
> 	char *CMD_ARGS[] = {"true", NULL};
> 	execveat(fd, CMD_ARGS[0], CMD_ARGS 0)
> 
> in other words, the changes that you see CMD_ARGS[0] == NULL for
> execveat() seem higher than for path-based exec.
> 
> To counter that we should probably at least update the execveat()
> manpage with a recommendation what CMD_ARGS[0] should be set to if it
> isn't allowed to be set to NULL anymore. This is why was asking what
> argv[0] is supposed to be if the binary doesn't take any arguments.

Sent a fix to our fstests now replacing the argv[0] as NULL with "".
