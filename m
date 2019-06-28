Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52E345A093
	for <lists+stable@lfdr.de>; Fri, 28 Jun 2019 18:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbfF1QMx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jun 2019 12:12:53 -0400
Received: from mail.cybernetics.com ([173.71.130.66]:51534 "EHLO
        mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726542AbfF1QMx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jun 2019 12:12:53 -0400
X-Greylist: delayed 1166 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Jun 2019 12:12:53 EDT
X-ASG-Debug-ID: 1561737196-0fb3b01884207410001-OJig3u
Received: from cybernetics.com ([10.10.4.126]) by mail.cybernetics.com with ESMTP id XuFS70LeVHHv7eb6 (version=SSLv3 cipher=DES-CBC3-SHA bits=112 verify=NO); Fri, 28 Jun 2019 11:53:16 -0400 (EDT)
X-Barracuda-Envelope-From: tonyb@cybernetics.com
X-ASG-Whitelist: Client
Received: from [10.157.2.224] (account tonyb HELO [192.168.200.1])
  by cybernetics.com (CommuniGate Pro SMTP 5.1.14)
  with ESMTPSA id 8967552; Fri, 28 Jun 2019 11:53:15 -0400
To:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>
From:   Tony Battersby <tonyb@cybernetics.com>
Subject: Regression: cannot compile kernel 4.14 with old gcc
Message-ID: <54a67814-1c9a-14c9-3a7d-947b08369514@cybernetics.com>
X-ASG-Orig-Subj: Regression: cannot compile kernel 4.14 with old gcc
Date:   Fri, 28 Jun 2019 11:53:15 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Barracuda-Connect: UNKNOWN[10.10.4.126]
X-Barracuda-Start-Time: 1561737196
X-Barracuda-Encrypted: DES-CBC3-SHA
X-Barracuda-URL: https://10.10.4.122:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at cybernetics.com
X-Barracuda-Scan-Msg-Size: 1424
X-Barracuda-BRTS-Status: 1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Old versions of gcc cannot compile 4.14 since 4.14.113:

./include/asm-generic/fixmap.h:37: error: implicit declaration of function ‘__builtin_unreachable’

The stable commit that caused the problem is 82017e26e515 ("compiler.h:
update definition of unreachable()") (upstream commit fe0640eb30b7). 
Reverting the commit fixes the problem.

Kernel 4.17 dropped support for older versions of gcc in upstream commit
cafa0010cd51 ("Raise the minimum required gcc version to 4.6").  This
was not backported to 4.14 since that would go against the stable kernel
rules.

Upstream commit 815f0ddb346c ("include/linux/compiler*.h: make
compiler-*.h mutually exclusive") was a fix for cafa0010cd51.  This was
not backported to 4.14.

Upstream commit fe0640eb30b7 ("compiler.h: update definition of
unreachable()") was a fix for 815f0ddb346c.  This is the commit that was
backported to 4.14.  But it only fixed a problem introduced in the other
commits, and without those commits, it ends up introducing a problem
instead of fixing one.  So I recommend reverting that patch in 4.14,
which will enable old gcc to compile 4.14 again.  If I understand
correctly, I believe that clang will still be able to compile 4.14 with
the patch reverted, although I haven't tried to compile with clang.

The problematic commit is not present in 4.9.x, 4.4.x, 3.18.x, or 3.16.x.

Tony Battersby
Cybernetics

