Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97728BD00C
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 19:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732117AbfIXRCz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 13:02:55 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:41441 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726897AbfIXRCz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Sep 2019 13:02:55 -0400
Received: by mail-io1-f68.google.com with SMTP id r26so6191341ioh.8
        for <stable@vger.kernel.org>; Tue, 24 Sep 2019 10:02:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2Y7JDpusl8uM4l8mJlIUSosd+8pd0KgH/eg88o1tZ+U=;
        b=bBjik4oxylm4BFTFdST470SXp7tQAXIXXCllcfpIbvpSGjjRBij5rJlT4f9moVFwVd
         yJyY9XiRopDZW9w6enKsHkDk6hUAVaDkV+sSltjPN+TOoA+ugIQsc4riRdaWLsEjaqWG
         9myLovEFNhXFizb3cXpb2n7XnotNVUKjcwMtZcwQxYBvtIuYSUfCo80jjoUM+Gq5AIil
         5NFy2LvkwmLWALy4eSt/ikTBnTPzzY5Oh2qIivwuyU72F/ymNSybxXBTpfk7Cgb3BNty
         EmwJ211u1yoWy6TpjEOJvCnSJJUNwjBledeadjd+aZxMeTPDvF8vZxiPZzBLGkbnCFXd
         8d9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2Y7JDpusl8uM4l8mJlIUSosd+8pd0KgH/eg88o1tZ+U=;
        b=RHwLMy86JPT00uTuW6h+RVERsif8UnTVUdQ8FgQpKPhNSksY+4DvrHjPYZsBg9SN0c
         xPQv3LE+L9EtGW+VmlM2Le2DX0j+QV8CTrOOh4dbp2G6p7sAYTjmpaJqnKu7zk73YIub
         3OwxC7Pn5s7OPHzvC/HfJSAJx98ZyjMGe06MApZvb1WlvjC+UtkeEn3demyx6pWp5hJP
         z6zs/k2Gw/QVYe0Y697d+CvTpDmjIg3iR2fFY3jLlEkxuM8vUQtzRLyUfJFZ346da9/D
         +0CouJJvbQBg47cgEsKq8LmX+UHBWYw0meN2ztEgC1NUbhKwqAE12xCvNG3kmJAtCA1u
         imVQ==
X-Gm-Message-State: APjAAAW9WsQ+wIR0rp0mV5qbFVMrvpOycjPY0WoCSP/hdfXGdVemnZtA
        R8EnefDTGDgoD813HulbFZTqyalqwVSvafVlSTC7Eg==
X-Google-Smtp-Source: APXvYqwZqEsuY5Y4M14Cr+5pAyN6PG6t2sd2N11O8P+s+hLu+UoU104Vs8aiyqs/fdO096/rYroxhs0sMoBn8tQLibs=
X-Received: by 2002:a5e:da0a:: with SMTP id x10mr100562ioj.286.1569344573717;
 Tue, 24 Sep 2019 10:02:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190924.145257.2013712373872209531.davem@davemloft.net> <20190924140128.19394-1-Jason@zx2c4.com>
In-Reply-To: <20190924140128.19394-1-Jason@zx2c4.com>
From:   Wei Wang <weiwan@google.com>
Date:   Tue, 24 Sep 2019 10:02:42 -0700
Message-ID: <CAEA6p_CEzzpgdQMw0KnOJYN+HVEFoShwnn0tAUqaQjO2+44BcQ@mail.gmail.com>
Subject: Re: [PATCH v2] ipv6: do not free rt if FIB_LOOKUP_NOREF is set on
 suppress rule
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 24, 2019 at 7:01 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Commit 7d9e5f422150 removed references from certain dsts, but accounting
> for this never translated down into the fib6 suppression code. This bug
> was triggered by WireGuard users who use wg-quick(8), which uses the
> "suppress-prefix" directive to ip-rule(8) for routing all of their
> internet traffic without routing loops. The test case added here
> causes the reference underflow by causing packets to evaluate a suppress
> rule.
>
> Cc: stable@vger.kernel.org
> Fixes: 7d9e5f422150 ("ipv6: convert major tx path to use RT6_LOOKUP_F_DST_NOREF")
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
Acked-by: Wei Wang <weiwan@google.com>

Good catch. Thanks for the fix.

>  net/ipv6/fib6_rules.c                    |  3 ++-
>  tools/testing/selftests/net/fib_tests.sh | 17 ++++++++++++++++-
>  2 files changed, 18 insertions(+), 2 deletions(-)
>
> diff --git a/net/ipv6/fib6_rules.c b/net/ipv6/fib6_rules.c
> index d22b6c140f23..f9e8fe3ff0c5 100644
> --- a/net/ipv6/fib6_rules.c
> +++ b/net/ipv6/fib6_rules.c
> @@ -287,7 +287,8 @@ static bool fib6_rule_suppress(struct fib_rule *rule, struct fib_lookup_arg *arg
>         return false;
>
>  suppress_route:
> -       ip6_rt_put(rt);
> +       if (!(arg->flags & FIB_LOOKUP_NOREF))
> +               ip6_rt_put(rt);
>         return true;
>  }
>
> diff --git a/tools/testing/selftests/net/fib_tests.sh b/tools/testing/selftests/net/fib_tests.sh
> index 4465fc2dae14..c2c5f2bf0f95 100755
> --- a/tools/testing/selftests/net/fib_tests.sh
> +++ b/tools/testing/selftests/net/fib_tests.sh
> @@ -9,7 +9,7 @@ ret=0
>  ksft_skip=4
>
>  # all tests in this script. Can be overridden with -t option
> -TESTS="unregister down carrier nexthop ipv6_rt ipv4_rt ipv6_addr_metric ipv4_addr_metric ipv6_route_metrics ipv4_route_metrics ipv4_route_v6_gw rp_filter"
> +TESTS="unregister down carrier nexthop suppress ipv6_rt ipv4_rt ipv6_addr_metric ipv4_addr_metric ipv6_route_metrics ipv4_route_metrics ipv4_route_v6_gw rp_filter"
>
>  VERBOSE=0
>  PAUSE_ON_FAIL=no
> @@ -614,6 +614,20 @@ fib_nexthop_test()
>         cleanup
>  }
>
> +fib_suppress_test()
> +{
> +       $IP link add dummy1 type dummy
> +       $IP link set dummy1 up
> +       $IP -6 route add default dev dummy1
> +       $IP -6 rule add table main suppress_prefixlength 0
> +       ping -f -c 1000 -W 1 1234::1 || true
> +       $IP -6 rule del table main suppress_prefixlength 0
> +       $IP link del dummy1
> +
> +       # If we got here without crashing, we're good.
> +       return 0
> +}
> +
>  ################################################################################
>  # Tests on route add and replace
>
> @@ -1591,6 +1605,7 @@ do
>         fib_carrier_test|carrier)       fib_carrier_test;;
>         fib_rp_filter_test|rp_filter)   fib_rp_filter_test;;
>         fib_nexthop_test|nexthop)       fib_nexthop_test;;
> +       fib_suppress_test|suppress)     fib_suppress_test;;
>         ipv6_route_test|ipv6_rt)        ipv6_route_test;;
>         ipv4_route_test|ipv4_rt)        ipv4_route_test;;
>         ipv6_addr_metric)               ipv6_addr_metric_test;;
> --
> 2.21.0
>
