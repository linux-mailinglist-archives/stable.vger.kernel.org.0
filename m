Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E92CA33B779
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232997AbhCOOAc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:00:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:35186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232482AbhCON66 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:58:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF81564F44;
        Mon, 15 Mar 2021 13:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816720;
        bh=RAhO4+QJnKn5fUdmktY/OvMRVJhUWkG2JgXMSuntQGM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z1858jc/DH6hWrccp9CIdWETrilC/ziNzajqoVgs51KXlng28GlZVTQV4qkjk0tNg
         8TnDvl9pTQdlpuuUG1qmrCTz1y0swiobxbbjy2WI7bS3JL2cazD5mO1xYCLFBuL/Ub
         VZlNWju51yWG9+Cb8nw0flbSNuWA3us4ZLLeUozA=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Athira Jajeev <atrajeev@linux.vnet.ibm.com>,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 5.10 074/290] perf report: Fix -F for branch & mem modes
Date:   Mon, 15 Mar 2021 14:52:47 +0100
Message-Id: <20210315135544.414893543@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Ravi Bangoria <ravi.bangoria@linux.ibm.com>

commit 6740a4e70e5d1b9d8e7fe41fd46dd5656d65dadf upstream.

perf report fails to add valid additional fields with -F when
used with branch or mem modes. Fix it.

Before patch:

  $ perf record -b
  $ perf report -b -F +srcline_from --stdio
  Error:
  Invalid --fields key: `srcline_from'

After patch:

  $ perf report -b -F +srcline_from --stdio
  # Samples: 8K of event 'cycles'
  # Event count (approx.): 8784
  ...

Committer notes:

There was an inversion: when looking at branch stack dimensions (keys)
it was checking if the sort mode was 'mem', not 'branch'.

Fixes: aa6b3c99236b ("perf report: Make -F more strict like -s")
Reported-by: Athira Jajeev <atrajeev@linux.vnet.ibm.com>
Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Reviewed-by: Athira Jajeev <atrajeev@linux.vnet.ibm.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Tested-by: Athira Jajeev <atrajeev@linux.vnet.ibm.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lore.kernel.org/lkml/20210304062958.85465-1-ravi.bangoria@linux.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/sort.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -3003,7 +3003,7 @@ int output_field_add(struct perf_hpp_lis
 		if (strncasecmp(tok, sd->name, strlen(tok)))
 			continue;
 
-		if (sort__mode != SORT_MODE__MEMORY)
+		if (sort__mode != SORT_MODE__BRANCH)
 			return -EINVAL;
 
 		return __sort_dimension__add_output(list, sd);
@@ -3015,7 +3015,7 @@ int output_field_add(struct perf_hpp_lis
 		if (strncasecmp(tok, sd->name, strlen(tok)))
 			continue;
 
-		if (sort__mode != SORT_MODE__BRANCH)
+		if (sort__mode != SORT_MODE__MEMORY)
 			return -EINVAL;
 
 		return __sort_dimension__add_output(list, sd);


