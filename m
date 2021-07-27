Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 482CB3D6ED2
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 08:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234905AbhG0GKi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 02:10:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:38540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235063AbhG0GKg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Jul 2021 02:10:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32358610E9;
        Tue, 27 Jul 2021 06:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627366235;
        bh=0AzEFGOjxf/nqKF8ihaSxAyjvpUdinANxy4J7kjkPy0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zUBCCu5wqFJdGBTODwgrokkJHUVi372Bas1ZuZC9JxpjvIJ0xfcPdDMR1E9bmWvdz
         Yk0z5kClHsmHAObH7a3DzS6RPEHRjDBbITQ/iy3Gq2xVaLSNQ8rclJy9ql/yO4DVo2
         xEOFEXd502tpKz5nEJH53LLQ+LfJb4zHY+qHKisc=
Date:   Tue, 27 Jul 2021 08:10:33 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Riccardo Mancini <rickyman7@gmail.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Kan Liang <kan.liang@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 065/120] perf test session_topology: Delete
 session->evlist
Message-ID: <YP+jWZu3p3hZGp40@kroah.com>
References: <20210726153832.339431936@linuxfoundation.org>
 <20210726153834.463666741@linuxfoundation.org>
 <CA+G9fYt-4cb_fcgTMkxg=RnKBDk8ipgvyW9MUgO2Bam+ounVng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYt-4cb_fcgTMkxg=RnKBDk8ipgvyW9MUgO2Bam+ounVng@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 27, 2021 at 09:14:44AM +0530, Naresh Kamboju wrote:
> On Mon, 26 Jul 2021 at 21:28, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > From: Riccardo Mancini <rickyman7@gmail.com>
> >
> > [ Upstream commit 233f2dc1c284337286f9a64c0152236779a42f6c ]
> >
> > ASan reports a memory leak related to session->evlist while running:
> >
> >   # perf test "41: Session topology".
> >
> > When perf_data is in write mode, session->evlist is owned by the caller,
> > which should also take care of deleting it.
> >
> > This patch adds the missing evlist__delete().
> >
> > Signed-off-by: Riccardo Mancini <rickyman7@gmail.com>
> > Fixes: c84974ed9fb67293 ("perf test: Add entry to test cpu topology")
> > Cc: Ian Rogers <irogers@google.com>
> > Cc: Jiri Olsa <jolsa@redhat.com>
> > Cc: Kan Liang <kan.liang@intel.com>
> > Cc: Mark Rutland <mark.rutland@arm.com>
> > Cc: Namhyung Kim <namhyung@kernel.org>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Link: http://lore.kernel.org/lkml/822f741f06eb25250fb60686cf30a35f447e9e91.1626343282.git.rickyman7@gmail.com
> > Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> 
> perf build failed on 4.19, 4.14, 4.9 and 4.4 due to these warnings / errors
> for all the architectures.

Now dropped from all of these trees.  Let me go push out -rc2 for all of
them as well...

thanks,

greg k-h
