Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08A6A40DEED
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240527AbhIPQFR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:05:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:44394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240518AbhIPQFR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:05:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 179A060232;
        Thu, 16 Sep 2021 16:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808236;
        bh=ObqOYrgdwAJO8POxMzYgQTUoEN6o0v/uM2wFd+WSdug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bZmqZeauKUONLcc5o8X8xpj6bLqLJUMYJmA0HhanbFsYYjJMjzRmt1pH2cIjV2VwW
         xJ6AjwbI4Ug7xg7ukTLDqpLZxegZOGpNBmkAW9/fvPk5dYXX9dd1DrSPmWsX4NI/AJ
         vWyt/ScC+QEnGPEoYzTRIzge/un3cYIwad4foSm0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nageswara R Sastry <rnsastry@linux.ibm.com>,
        Kajol Jain <kjain@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.10 012/306] powerpc/perf/hv-gpci: Fix counter value parsing
Date:   Thu, 16 Sep 2021 17:55:57 +0200
Message-Id: <20210916155754.337715370@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kajol Jain <kjain@linux.ibm.com>

commit f9addd85fbfacf0d155e83dbee8696d6df5ed0c7 upstream.

H_GetPerformanceCounterInfo (0xF080) hcall returns the counter data in
the result buffer. Result buffer has specific format defined in the PAPR
specification. One of the fields is counter offset and width of the
counter data returned.

Counter data are returned in a unsigned char array in big endian byte
order. To get the final counter data, the values must be left shifted
byte at a time. But commit 220a0c609ad17 ("powerpc/perf: Add support for
the hv gpci (get performance counter info) interface") made the shifting
bitwise and also assumed little endian order. Because of that, hcall
counters values are reported incorrectly.

In particular this can lead to counters go backwards which messes up the
counter prev vs now calculation and leads to huge counter value
reporting:

  #: perf stat -e hv_gpci/system_tlbie_count_and_time_tlbie_instructions_issued/
           -C 0 -I 1000
        time             counts unit events
     1.000078854 18,446,744,073,709,535,232      hv_gpci/system_tlbie_count_and_time_tlbie_instructions_issued/
     2.000213293                  0      hv_gpci/system_tlbie_count_and_time_tlbie_instructions_issued/
     3.000320107                  0      hv_gpci/system_tlbie_count_and_time_tlbie_instructions_issued/
     4.000428392                  0      hv_gpci/system_tlbie_count_and_time_tlbie_instructions_issued/
     5.000537864                  0      hv_gpci/system_tlbie_count_and_time_tlbie_instructions_issued/
     6.000649087                  0      hv_gpci/system_tlbie_count_and_time_tlbie_instructions_issued/
     7.000760312                  0      hv_gpci/system_tlbie_count_and_time_tlbie_instructions_issued/
     8.000865218             16,448      hv_gpci/system_tlbie_count_and_time_tlbie_instructions_issued/
     9.000978985 18,446,744,073,709,535,232      hv_gpci/system_tlbie_count_and_time_tlbie_instructions_issued/
    10.001088891             16,384      hv_gpci/system_tlbie_count_and_time_tlbie_instructions_issued/
    11.001201435                  0      hv_gpci/system_tlbie_count_and_time_tlbie_instructions_issued/
    12.001307937 18,446,744,073,709,535,232      hv_gpci/system_tlbie_count_and_time_tlbie_instructions_issued/

Fix the shifting logic to correct match the format, ie. read bytes in
big endian order.

Fixes: e4f226b1580b ("powerpc/perf/hv-gpci: Increase request buffer size")
Cc: stable@vger.kernel.org # v4.6+
Reported-by: Nageswara R Sastry<rnsastry@linux.ibm.com>
Signed-off-by: Kajol Jain <kjain@linux.ibm.com>
Tested-by: Nageswara R Sastry<rnsastry@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210813082158.429023-1-kjain@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/perf/hv-gpci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/perf/hv-gpci.c
+++ b/arch/powerpc/perf/hv-gpci.c
@@ -175,7 +175,7 @@ static unsigned long single_gpci_request
 	 */
 	count = 0;
 	for (i = offset; i < offset + length; i++)
-		count |= arg->bytes[i] << (i - offset);
+		count |= (u64)(arg->bytes[i]) << ((length - 1 - (i - offset)) * 8);
 
 	*value = count;
 out:


