Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 213CCBBA9C
	for <lists+stable@lfdr.de>; Mon, 23 Sep 2019 19:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394148AbfIWRh3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Sep 2019 13:37:29 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:38436 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389167AbfIWRh3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Sep 2019 13:37:29 -0400
Received: by mail-qt1-f195.google.com with SMTP id j31so18165528qta.5
        for <stable@vger.kernel.org>; Mon, 23 Sep 2019 10:37:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=NxPO3Yj4ypp5wuosR7Uau5wG7ddOivaedhYE1YM0o/0=;
        b=Gmi8wRsOBlQKh9dTAckF38xJY3Or599hk3p7rzBiy4TxOACn6PZk+HcNKoCPRFI5qm
         UbjFnT1F9ApsRswNgDg2YX0pKRIy+98kdgQFAb8NslFXDMNwS0iCBkMiKOYSHSjwQI5a
         cp1bzKUOIL4EvTMapfSWrAttMKZLFBNghAWODmxETwh4K9a2VfWelXPk4PqtCcxg2PN4
         Jf9YXGfOpfClis8/JrhGQ5oG2uPcgE2WMX05D1y6HNFK3djTSwkbpXStwoux5tVtk0lw
         yCoy860fpBbw4ZJM2x4O/WNVpYWVcx2PH77pzOvf3KxmxwQELDPG9VxI3u+1Vi/wN6Sa
         VXrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=NxPO3Yj4ypp5wuosR7Uau5wG7ddOivaedhYE1YM0o/0=;
        b=HxcL2P8argt8ENf/vrva6/Pw7864jrgQ2Y0ktxefFndU+6oOm+QCX2OuMUC35Mn5Oa
         2ILTq1Y9DmFaShLsBx6DlG6AKTrL/tOTySLv2O0xAQi7M88zD82aa9tHbRgZhZL39+2M
         EWamF63gPC7C9GXk88E/GDSeC1fSUkclBSQeFC6i18ZqAj0NRtt8dOdKnFHaru2ezXKx
         x6YvllIem84qJjJWLrPBPqa/9AbPJ+UablGSEfLjssbkGJhJgQf+DOod7k6QJdelqqSh
         JIf3XrAbV8rXGrJUtNfWDVDXVnRBI7s8X0OQroKwZhH6DEG6EvCxufw1i2Y0CPjRemRl
         ZJwQ==
X-Gm-Message-State: APjAAAUammm4fJm50V/Ddix0rNCD7wmi8wm07v9pvjzd07a+aWgXCvff
        Wwf1sVWePEOqPGkG6UnlxpU=
X-Google-Smtp-Source: APXvYqyqCneeLwIrLCtyTGBusg4Ur/TDOsA0DTP6Wd3sDATYA7WrK8EzyGTt9i1DFPnRsT3ktk88Pg==
X-Received: by 2002:ac8:75c7:: with SMTP id z7mr1224783qtq.136.1569260246586;
        Mon, 23 Sep 2019 10:37:26 -0700 (PDT)
Received: from quaco.ghostprotocols.net (189-94-129-1.3g.claro.net.br. [189.94.129.1])
        by smtp.gmail.com with ESMTPSA id c14sm6663598qta.80.2019.09.23.10.37.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Sep 2019 10:37:25 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id E59B641105; Mon, 23 Sep 2019 14:37:19 -0300 (-03)
Date:   Mon, 23 Sep 2019 14:37:19 -0300
To:     Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc:     Sasha Levin <sashal@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH 26/31] perf stat: Reset previous counts on repeat with
 interval
Message-ID: <20190923173719.GA28265@kernel.org>
References: <20190920142542.12047-27-acme@kernel.org>
 <20190921120623.7B67920717@mail.kernel.org>
 <20190923142314.GA24338@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190923142314.GA24338@linux.vnet.ibm.com>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Em Mon, Sep 23, 2019 at 09:58:54PM +0530, Srikar Dronamraju escreveu:
> Hi Sasha, Arnaldo.
> 
> Between v5.2.16 and acme HEAD, struct perf_evlist to struct evlist and 
> struct perf_evsel to struct evsel.
> 
> However the patches that I had posted
> http://lkml.kernel.org/r/20190904094738.9558-2-srikar@linux.vnet.ibm.com
> would apply cleanly to v5.2.16.
> 
> I would like to check if the backports to v5.2.16 should be the same patch
> (i.e include dependencies including struct renames) or is it okay to apply
> without the dependencies. Please advise.
> 
> Because the renames affected a lot of files, it throws up a lot of commits
> as dependencies. So I would wait for your inputs before I start with the
> work.

Better to not drag the renames, just use the original patch, I think its
the best path forward (well, backward :)).

- Arnaldo
 
> --
> Thanks and Regards
> Srikar
> 
> 
> > 
> > The bot has tested the following trees: v5.2.16, v4.19.74, v4.14.145, v4.9.193, v4.4.193.
> > 
> > v5.2.16: Failed to apply! Possible dependencies:
> >     1c839a5a4061 ("perf cs-etm: Configure timestamp generation in CPU-wide mode")
> >     32dcd021d004 ("perf evsel: Rename struct perf_evsel to struct evsel")
> >     3399ad9ac234 ("perf cs-etm: Configure contextID tracing in CPU-wide mode")
> >     acae8b36cded ("perf header: Add die information in CPU topology")
> >     b74d8686a18b ("perf cpumap: Retrieve die id information")
> >     db5742b6849e ("perf stat: Support per-die aggregation")
> >     f854839ba2a5 ("perf cpu_map: Rename struct cpu_map to struct perf_cpu_map")
> > 
> 
> -- 
> Thanks and Regards
> Srikar Dronamraju

-- 

- Arnaldo
