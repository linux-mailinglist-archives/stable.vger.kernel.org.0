Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6137BE2AA
	for <lists+stable@lfdr.de>; Wed, 25 Sep 2019 18:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390406AbfIYQkw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Sep 2019 12:40:52 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50650 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728465AbfIYQkw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Sep 2019 12:40:52 -0400
Received: by mail-wm1-f65.google.com with SMTP id 5so6527356wmg.0;
        Wed, 25 Sep 2019 09:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=ewxpB7bKwZOLfzm0lqLxAsWHdJjqZ2WWi1tIbZVyLyE=;
        b=rhDLdfx2ReErh/vru6Be0Tp3aiY8888Wm6I+gHYFdcfJHiAABt6YtR0LPcc71XIjHi
         hUsI4IY3shGzQxRD8IaUYeNuazsi0p9UqF6rD1IdrRxSB9vZUwDN1BOzIo+oTcovnYIh
         P1WCacPd+CMbkrtwh1H1gQZ2evYz7xc3kr3STWipmYEhlP3efTl7d8GSd81TOZ1g9YOo
         NsQTtwmFwCOjIDIK3s5oQHwKFVoXXK7T34Ft0xBwZ4M5Y2PlCw80zzlfMclUYX2pylkj
         en5JJZ7PAackdB3SErCh3YyWCJMydkPJmLkaRIy8F9yyfpDo0gLnbE4Ww8MdVzlmVG8n
         CFEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=ewxpB7bKwZOLfzm0lqLxAsWHdJjqZ2WWi1tIbZVyLyE=;
        b=DZb54V4CqEpML01dXX89HZ+N5z+TT7vJomAaW5N/la/ykD9M1iG3JTcHK8xxq0yTZU
         paonGFpKhgHYH10PhpL1x8XInf/fepbhiCv3+ec+tuI14feCVi5mNcCBEGqkgxg4UNrB
         AyekH1br00Ku2xnJzPOXHI86MifOno/j67IrgY0WLMqI78rTj6NdHoJOK/KgwTV/Kg35
         4daPwHhQRt9V0pqx6fBVNb6xGZ/+3GLO2/dEWcPmrvpjpOa1TDny6l8O99LnlYK3AlTO
         fyL3478O+nmkTp1HHB255pHEMbPPEqZTEc4wtjBDLvV3vK9gi+iByKeCjFwGKFQxzVe/
         MsHA==
X-Gm-Message-State: APjAAAUovUHOlq6mS4tZcG5wuE1qOcQCWCZt8WpJ+5C+PQWhV0X6ujYX
        vW+gqWVVoshNyPd5yqi7Xm0=
X-Google-Smtp-Source: APXvYqyub3xdz+LV0bD39VXYCI+UEOrOOEm+scHVRtUmuiIhvhQB0zrjTeJjrBdw0seYYPAUM7cGAA==
X-Received: by 2002:a05:600c:215:: with SMTP id 21mr8857879wmi.170.1569429649685;
        Wed, 25 Sep 2019 09:40:49 -0700 (PDT)
Received: from archlinux-threadripper ([2a01:4f8:222:2f1b::2])
        by smtp.gmail.com with ESMTPSA id b144sm6128053wmb.3.2019.09.25.09.40.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2019 09:40:49 -0700 (PDT)
Date:   Wed, 25 Sep 2019 09:40:47 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Request for inclusion of f73b3cc39c84 ("objtool: Clobber user CFLAGS
 variable") in -stable
Message-ID: <20190925164047.GA471117@archlinux-threadripper>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg and Sasha,

We received a report of an objtool build failure with clang related to
-Wunused-parameter [1], which turned out to be related to the distro's
CFLAGS. Josh patched this up in commit f73b3cc39c84 ("objtool: Clobber
user CFLAGS variable"), could it be added to -stable whenever
applicable? Looks like it will pick cleanly to 4.19 but it can be
applied to 4.14 with context differences.

Josh and Peter, would you be interested in patches that fix and then
enable -Wunused-parameter? There are only a couple of warnings. Let
me know, I can send my patches along.

[1]: https://github.com/ClangBuiltLinux/linux/issues/676

Cheers,
Nathan
