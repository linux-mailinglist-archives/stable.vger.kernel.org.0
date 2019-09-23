Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83A26BB995
	for <lists+stable@lfdr.de>; Mon, 23 Sep 2019 18:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732748AbfIWQ3F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Sep 2019 12:29:05 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39844 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726328AbfIWQ3F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Sep 2019 12:29:05 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8NGHULc139699
        for <stable@vger.kernel.org>; Mon, 23 Sep 2019 12:29:04 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2v6yr44qwm-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Mon, 23 Sep 2019 12:29:03 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <srikar@linux.vnet.ibm.com>;
        Mon, 23 Sep 2019 17:29:02 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 23 Sep 2019 17:28:58 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8NGSvOd50331888
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Sep 2019 16:28:57 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 30088AE04D;
        Mon, 23 Sep 2019 16:28:57 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 026BAAE055;
        Mon, 23 Sep 2019 16:28:55 +0000 (GMT)
Received: from linux.vnet.ibm.com (unknown [9.85.91.202])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Mon, 23 Sep 2019 16:28:54 +0000 (GMT)
Date:   Mon, 23 Sep 2019 21:58:54 +0530
From:   Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH 26/31] perf stat: Reset previous counts on repeat with
 interval
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20190920142542.12047-27-acme@kernel.org>
 <20190921120623.7B67920717@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20190921120623.7B67920717@mail.kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-TM-AS-GCONF: 00
x-cbid: 19092316-0016-0000-0000-000002AFA5FA
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19092316-0017-0000-0000-00003310642B
Message-Id: <20190923142314.GA24338@linux.vnet.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-23_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1909230153
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha, Arnaldo.

Between v5.2.16 and acme HEAD, struct perf_evlist to struct evlist and 
struct perf_evsel to struct evsel.

However the patches that I had posted
http://lkml.kernel.org/r/20190904094738.9558-2-srikar@linux.vnet.ibm.com
would apply cleanly to v5.2.16.

I would like to check if the backports to v5.2.16 should be the same patch
(i.e include dependencies including struct renames) or is it okay to apply
without the dependencies. Please advise.

Because the renames affected a lot of files, it throws up a lot of commits
as dependencies. So I would wait for your inputs before I start with the
work.

--
Thanks and Regards
Srikar


> 
> The bot has tested the following trees: v5.2.16, v4.19.74, v4.14.145, v4.9.193, v4.4.193.
> 
> v5.2.16: Failed to apply! Possible dependencies:
>     1c839a5a4061 ("perf cs-etm: Configure timestamp generation in CPU-wide mode")
>     32dcd021d004 ("perf evsel: Rename struct perf_evsel to struct evsel")
>     3399ad9ac234 ("perf cs-etm: Configure contextID tracing in CPU-wide mode")
>     acae8b36cded ("perf header: Add die information in CPU topology")
>     b74d8686a18b ("perf cpumap: Retrieve die id information")
>     db5742b6849e ("perf stat: Support per-die aggregation")
>     f854839ba2a5 ("perf cpu_map: Rename struct cpu_map to struct perf_cpu_map")
> 

-- 
Thanks and Regards
Srikar Dronamraju

