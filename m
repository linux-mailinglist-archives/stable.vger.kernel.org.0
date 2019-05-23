Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33F5C28544
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 19:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731117AbfEWRr4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 13:47:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:52752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730899AbfEWRr4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 13:47:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38F772184B;
        Thu, 23 May 2019 17:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558633675;
        bh=qSP3OnYAbptsHLrP7wuWhN2bIkr8rj9sublY3K28GdM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yHHZPFo133t6zqKAHluV7hUzMeYAH0NrF+17oYtcmPvpClPwKWtvu8qZG288zwd5n
         Lu1+E1JtWi8VhJGD0bMlWyFkGzttfqi5xsj1pCCWHTl0QUyisCEoFZgktSY16Kg4+y
         Bzx/Qc2SLzGcu5SGhGyHTqfaplW1B4f9ErbcwAjI=
Date:   Thu, 23 May 2019 19:47:53 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "sdf@google.com" <sdf@google.com>
Subject: Re: [PATCH 4.19 144/187] selftests/bpf: skip verifier tests for
 unsupported program types
Message-ID: <20190523174753.GE29438@kroah.com>
References: <20190404084603.119654039@linuxfoundation.org>
 <20190404084609.946908305@linuxfoundation.org>
 <16ec5436310b0df657a4898e3d15ccc3b9aab8e2.camel@nokia.com>
 <47a9ede3-bef8-7ae1-6353-b954b6e7f7af@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47a9ede3-bef8-7ae1-6353-b954b6e7f7af@iogearbox.net>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 23, 2019 at 03:46:26PM +0200, Daniel Borkmann wrote:
> On 05/23/2019 12:27 PM, Rantala, Tommi T. (Nokia - FI/Espoo) wrote:
> > On Thu, 2019-04-04 at 10:48 +0200, Greg Kroah-Hartman wrote:
> >> 4.19-stable review patch.  If anyone has any objections, please let
> >> me know.
> >>
> >> ------------------
> >>
> >> [ Upstream commit 8184d44c9a577a2f1842ed6cc844bfd4a9981d8e ]
> >>
> >> Use recently introduced bpf_probe_prog_type() to skip tests in the
> >> test_verifier() if bpf_verify_program() fails. The skipped test is
> >> indicated in the output.
> > 
> > Hi, this patch added in 4.19.34 causes test_verifier build failure, as
> > bpf_probe_prog_type() is not available:
> > 
> > gcc -Wall -O2 -I../../../include/uapi -I../../../lib -I../../../lib/bpf
> > -I../../../../include/generated -DHAVE_GENHDR
> > -I../../../include    test_verifier.c /root/linux-
> > 4.19.44/tools/testing/selftests/bpf/libbpf.a -lcap -lelf -lrt -lpthread
> > -o /root/linux-4.19.44/tools/testing/selftests/bpf/test_verifier
> > test_verifier.c: In function ‘do_test_single’:
> > test_verifier.c:12775:22: warning: implicit declaration of function
> > ‘bpf_probe_prog_type’; did you mean ‘bpf_program__set_type’? [-
> > Wimplicit-function-declaration]
> >   if (fd_prog < 0 && !bpf_probe_prog_type(prog_type, 0)) {
> >                       ^~~~~~~~~~~~~~~~~~~
> >                       bpf_program__set_type
> > /usr/bin/ld: /tmp/ccEtyLhk.o: in function `do_test_single':
> > test_verifier.c:(.text+0xa19): undefined reference to
> > `bpf_probe_prog_type'
> > collect2: error: ld returned 1 exit status
> > make[1]: *** [../lib.mk:152: /root/linux-
> > 4.19.44/tools/testing/selftests/bpf/test_verifier] Error 1
> 
> Looks like this kselftest one got auto-selected for stable? It's not
> strictly needed, so totally fine to drop.

Ok, will go revert this, sorry for the breakage.

greg k-h
