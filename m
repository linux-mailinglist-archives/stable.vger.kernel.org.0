Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FAA6F55BA
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:02:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389796AbfKHTEX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:04:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:34308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732007AbfKHTEX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:04:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 778BB215EA;
        Fri,  8 Nov 2019 19:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239863;
        bh=Ym3tbnkMskjzJwY1CtiRI7JO2MU1eYatws5riwUGJcY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZmrfV+QrygAL6WcI0k7c6s/svcUe+nN2nNwDsXVz4FXbOjEmrqd57+w6K0vqurjT4
         eEADE/EY8r8LCCw2/Q8RUCdo6aLzczBMoG3AzfawkZ9W3A2tIFPWkuF14QFiY1KIlr
         GbeSlxuvl3PowaZp2WL/FH/2An/L+SLcHdmS6X5Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Desnes A. Nunes do Rosario" <desnesn@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sandipan Das <sandipan@linux.ibm.com>
Subject: [PATCH 4.19 76/79] selftests/powerpc: Fix compile error on tlbie_test due to newer gcc
Date:   Fri,  8 Nov 2019 19:50:56 +0100
Message-Id: <20191108174828.530612166@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174745.495640141@linuxfoundation.org>
References: <20191108174745.495640141@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Desnes A. Nunes do Rosario <desnesn@linux.ibm.com>

commit 5b216ea1c40cf06eead15054c70e238c9bd4729e upstream.

Newer versions of GCC (>= 9) demand that the size of the string to be
copied must be explicitly smaller than the size of the destination.
Thus, the NULL char has to be taken into account on strncpy.

This will avoid the following compiling error:

  tlbie_test.c: In function 'main':
  tlbie_test.c:639:4: error: 'strncpy' specified bound 100 equals destination size
      strncpy(logdir, optarg, LOGDIR_NAME_SIZE);
      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  cc1: all warnings being treated as errors

Signed-off-by: Desnes A. Nunes do Rosario <desnesn@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20191003211010.9711-1-desnesn@linux.ibm.com
[sandipan: Backported to v4.19]
Signed-off-by: Sandipan Das <sandipan@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/testing/selftests/powerpc/mm/tlbie_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/powerpc/mm/tlbie_test.c
+++ b/tools/testing/selftests/powerpc/mm/tlbie_test.c
@@ -636,7 +636,7 @@ int main(int argc, char *argv[])
 			nrthreads = strtoul(optarg, NULL, 10);
 			break;
 		case 'l':
-			strncpy(logdir, optarg, LOGDIR_NAME_SIZE);
+			strncpy(logdir, optarg, LOGDIR_NAME_SIZE - 1);
 			break;
 		case 't':
 			run_time = strtoul(optarg, NULL, 10);


