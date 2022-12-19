Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0455650BE6
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 13:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231648AbiLSMmN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 07:42:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231439AbiLSMmL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 07:42:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6751BDFC6;
        Mon, 19 Dec 2022 04:42:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1DE45B80E0E;
        Mon, 19 Dec 2022 12:42:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B2EFC433F2;
        Mon, 19 Dec 2022 12:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671453727;
        bh=Tn9mf6KkjelrcTKj1IdFXGj3T1cbY56aU9U6ynMx0yw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kodQKXx+MIWmz17WVUePuq95c4DD9KeoSIcW6oCun7trjUru/D+Yuz6s9M5CrS5/C
         KGdR0CAjPvTO0F4eksphJ09BDzHQyscPNvHjM2H2tFe8nYMxkuIUerS9iyjxTO7Ei/
         4j1nYIkKqkqICIC/aFd5actl7+aWYVIizJKp/YZg=
Date:   Mon, 19 Dec 2022 13:42:00 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     FRANJOU Stephane <stephane.franjou@csgroup.eu>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Tony Jones <tonyj@suse.de>, Jiri Olsa <jolsa@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>,
        Seeteena Thoufeek <s1seetee@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] [Backport for 4.14] perf script python: Remove explicit
 shebang from tests/attr.c
Message-ID: <Y6BcGM6k1PM9+/4Q@kroah.com>
References: <3ca0515edb717e0f394f973f3cbbe2c80abb35e4.1671190496.git.christophe.leroy@csgroup.eu>
 <Y6BWeFdJiz/tIhQ6@kroah.com>
 <617a746a-5f64-6d7c-48df-7c96b3aca535@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <617a746a-5f64-6d7c-48df-7c96b3aca535@csgroup.eu>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 19, 2022 at 12:21:47PM +0000, Christophe Leroy wrote:
> 
> 
> Le 19/12/2022 à 13:18, Greg KH a écrit :
> > On Fri, Dec 16, 2022 at 12:38:12PM +0100, Christophe Leroy wrote:
> >> From: Tony Jones <tonyj@suse.de>
> >>
> >> [Upstream commit d72eadbc1d2866fc047edd4535ffb0298fe240be]
> >>
> >> tests/attr.c invokes attr.py via an explicit invocation of Python
> >> ($PYTHON) so there is therefore no need for an explicit shebang.
> >>
> >> Also most distros follow pep-0394 which recommends that /usr/bin/python
> >> refer only to v2 and so may not exist on the system (if PYTHON=python3).
> >>
> >> Signed-off-by: Tony Jones <tonyj@suse.de>
> >> Acked-by: Jiri Olsa <jolsa@kernel.org>
> >> Cc: Jonathan Corbet <corbet@lwn.net>
> >> Cc: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
> >> Cc: Seeteena Thoufeek <s1seetee@linux.vnet.ibm.com>
> >> Link: http://lkml.kernel.org/r/20190124005229.16146-5-tonyj@suse.de
> >> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> >> Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
> >> ---
> >>   tools/perf/tests/attr.py | 1 -
> >>   1 file changed, 1 deletion(-)
> > 
> > Why only 4.14?  What about 4.19?
> > 
> 
> 
> I submitted that backport because I encountered the problem while 
> building perf for 4.14.
> 
> I didn't look at other kernel versions.

In the future, remember that we can not add fixes to an older version
and not a newer one, otherwise you would have a regression moving to a
newer kernel.

thanks,

greg k-h
