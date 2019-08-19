Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB91492649
	for <lists+stable@lfdr.de>; Mon, 19 Aug 2019 16:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbfHSOPp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Aug 2019 10:15:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11932 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726751AbfHSOPp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Aug 2019 10:15:45 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BD5433A20F;
        Mon, 19 Aug 2019 14:15:44 +0000 (UTC)
Received: from krava (unknown [10.43.17.33])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 07983831A3;
        Mon, 19 Aug 2019 14:15:40 +0000 (UTC)
Date:   Mon, 19 Aug 2019 16:15:40 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Jack Wang <jack.wang.usish@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Vince Weaver <vincent.weaver@maine.edu>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH AUTOSEL 4.4 04/14] perf header: Fix divide by zero error
 if f_header.attr_size==0
Message-ID: <20190819141540.GC9637@krava>
References: <20190806213749.20689-1-sashal@kernel.org>
 <20190806213749.20689-4-sashal@kernel.org>
 <CA+res+RryNtrD3pydEn1G9HWnkDS780AaBEQQPNRqkx8rSzGJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+res+RryNtrD3pydEn1G9HWnkDS780AaBEQQPNRqkx8rSzGJA@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Mon, 19 Aug 2019 14:15:45 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 19, 2019 at 02:07:53PM +0200, Jack Wang wrote:
> Sasha Levin <sashal@kernel.org> 于2019年8月6日周二 下午11:39写道：
> >
> > From: Vince Weaver <vincent.weaver@maine.edu>
> >
> > [ Upstream commit 7622236ceb167aa3857395f9bdaf871442aa467e ]
> >
> > So I have been having lots of trouble with hand-crafted perf.data files
> > causing segfaults and the like, so I have started fuzzing the perf tool.
> >
> > First issue found:
> >
> > If f_header.attr_size is 0 in the perf.data file, then perf will crash
> > with a divide-by-zero error.
> >
> > Committer note:
> >
> > Added a pr_err() to tell the user why the command failed.
> >
> > Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>
> > Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> > Cc: Jiri Olsa <jolsa@redhat.com>
> > Cc: Namhyung Kim <namhyung@kernel.org>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Link: http://lkml.kernel.org/r/alpine.DEB.2.21.1907231100440.14532@macbook-air
> > Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  tools/perf/util/header.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> Hi all,
> 
> This on cause build failure when I rebased to 4.14.140-rc1 in stable-rc tree.
> 
>     util/header.c: In function 'perf_session__read_header':
>     util/header.c:2907:10: error: 'data' undeclared (first use in this
> function); did you mean 'dots'?
>               data->file.path);
>   Should be fixed by:
> --- a/tools/perf/util/header.c
> +++ b/tools/perf/util/header.c
> @@ -2904,7 +2904,7 @@ int perf_session__read_header(struct
> perf_session *session)
>         if (f_header.attr_size == 0) {
>                 pr_err("ERROR: The %s file's attr size field is 0
> which is unexpected.\n"
>                        "Was the 'perf record' command properly terminated?\n",
> -                      data->file.path);
> +                      file->path);
>                 return -EINVAL;

seems as good fix for 4.4, we took following commit in 4.15:
  eae8ad8042d8 perf tools: Add struct perf_data_file

that added the file layer

jirka

> 
> Regards,
> Jack Wang
> 
> > diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> > index 304f5d7101436..0102dd46fb6da 100644
> > --- a/tools/perf/util/header.c
> > +++ b/tools/perf/util/header.c
> > @@ -2591,6 +2591,13 @@ int perf_session__read_header(struct perf_session *session)
> >                            file->path);
> >         }
> >
> > +       if (f_header.attr_size == 0) {
> > +               pr_err("ERROR: The %s file's attr size field is 0 which is unexpected.\n"
> > +                      "Was the 'perf record' command properly terminated?\n",
> > +                      data->file.path);
> > +               return -EINVAL;
> > +       }
> > +
> >         nr_attrs = f_header.attrs.size / f_header.attr_size;
> >         lseek(fd, f_header.attrs.offset, SEEK_SET);
> >
> > --
> > 2.20.1
> >
