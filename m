Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDA354CEA2A
	for <lists+stable@lfdr.de>; Sun,  6 Mar 2022 10:09:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbiCFJKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Mar 2022 04:10:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiCFJKM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Mar 2022 04:10:12 -0500
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 704F22E0AF
        for <stable@vger.kernel.org>; Sun,  6 Mar 2022 01:09:20 -0800 (PST)
Received: by mail-qv1-xf2d.google.com with SMTP id kl20so275492qvb.10
        for <stable@vger.kernel.org>; Sun, 06 Mar 2022 01:09:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :mime-version;
        bh=mqJK3EpnAY54KA0CU5z37eTKddxlbF1kPQGw6UPLIso=;
        b=NU/W0+Pqv2fOWCRSlJLXDHCirpHkv4c6Aio1ormqNvq82aOKhxnmaN3h5Qq14ZuUPv
         S7i4dcAtwcITya7As8dl75WFefXYdBLby9UnN+vIibnHy+q6TSwgy6ln6e753UGHdCKr
         KPgHFjW5YkGb790otOEbzsUq0SacIq6Gyv8vgUsBHjaZtVQ4MIxG6RrXHVakfj3G26qn
         tI2U1b8n4ogfwLo15c1gknoCiRS1LXZMbqNokqLJcQCkcytCuGexgdcdkoJgS8MMdnD7
         jHtw3jeI0x2W+bzI4BM/I77oGqrMxWDxYl8fXpGn3L/mTA7KYYJIhtX5cSRbYyvS+G4l
         HwKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:mime-version;
        bh=mqJK3EpnAY54KA0CU5z37eTKddxlbF1kPQGw6UPLIso=;
        b=Iq+chC3VNdEOLuh4z9XgExBRXdK2VIlceaE6aTbhmKYpyXESCOhycbXL2yrYkyV3BE
         ZAgaSjsxoB4a9nUX5lQVS01sSk8IHsoi5AiDCFSV4EMQLBbaPlt47b+9gNgtUB1Km5B6
         GMTxp1SQexljAquqsswuCmr+Qa221fOdfchOCDVNUDoxmxyYvieGX1vsLZrFHpmi72uh
         Q4TZMJgJb/ouIPeHRk+lYeQLFeCie+rvCuQ7ZZmXQ0OwZNcEJMy4SzVmPVW2UlU2TQC0
         1t4DgCvscB3Rw8N/HjPpHOAZctiBMUEjcsZ9H0gm4G4lNzF7sO7v3QQg4rvE3BpVyHvU
         9MIg==
X-Gm-Message-State: AOAM5338tjHxzAWUsEgPn1CA0906Ef8c3ns5Jzs8S4YT7y15jvTHqB++
        8UlJa27NB3PJwdBA09clxFPCYw==
X-Google-Smtp-Source: ABdhPJwxIC6ssbECQ/OnY46cv+UGa5MU9uQofgAjHXQ+Hfks/my34c1a5/esfQiPvxBVBzWq000pYA==
X-Received: by 2002:a05:6214:f08:b0:433:6cf:9f7c with SMTP id gw8-20020a0562140f0800b0043306cf9f7cmr4709016qvb.71.1646557759357;
        Sun, 06 Mar 2022 01:09:19 -0800 (PST)
Received: from ripple.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id d84-20020a379b57000000b00649177bc987sm4703439qke.131.2022.03.06.01.09.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 01:09:18 -0800 (PST)
Date:   Sun, 6 Mar 2022 01:09:16 -0800 (PST)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@ripple.anvils
To:     gregkh@linuxfoundation.org
cc:     akpm@linux-foundation.org, cgel.zte@gmail.com, hughd@google.com,
        kirill@shutemov.name, mike.kravetz@oracle.com,
        songliubraving@fb.com, torvalds@linux-foundation.org,
        wang.yong12@zte.com.cn, willy@infradead.org,
        yang.yang29@zte.com.cn, zealci@zte.com.cn, yongw.pur@gmail.com,
        stable@vger.kernel.org
Subject: Re: Patch "memfd: fix F_SEAL_WRITE after shmem huge page allocated"
 has been added to the 5.4-stable tree
In-Reply-To: <1646512773164108@kroah.com>
Message-ID: <d169b785-1486-7c3d-7843-e2c23870a048@google.com>
References: <1646512773164108@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 5 Mar 2022, gregkh@linuxfoundation.org wrote:
> 
> This is a note to let you know that I've just added the patch titled
> 
>     memfd: fix F_SEAL_WRITE after shmem huge page allocated
> 
> to the 5.4-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>      memfd-fix-f_seal_write-after-shmem-huge-page-allocated.patch
> and it can be found in the queue-5.4 subdirectory.

Thank you for adding that patch to 5.16, 5.15, 5.10 and 5.4:
please accept the substitute patch below for 4.14 and 4.9 - thanks.
A different patch for 4.19 has been sent separately.

From f2b277c4d1c63a85127e8aa2588e9cc3bd21cb99 Mon Sep 17 00:00:00 2001
From: Hugh Dickins <hughd@google.com>
Date: Fri, 4 Mar 2022 20:29:01 -0800
Subject: memfd: fix F_SEAL_WRITE after shmem huge page allocated

From: Hugh Dickins <hughd@google.com>

commit f2b277c4d1c63a85127e8aa2588e9cc3bd21cb99 upstream.

Wangyong reports: after enabling tmpfs filesystem to support transparent
hugepage with the following command:

  echo always > /sys/kernel/mm/transparent_hugepage/shmem_enabled

the docker program tries to add F_SEAL_WRITE through the following
command, but it fails unexpectedly with errno EBUSY:

  fcntl(5, F_ADD_SEALS, F_SEAL_WRITE) = -1.

That is because memfd_tag_pins() and memfd_wait_for_pins() were never
updated for shmem huge pages: checking page_mapcount() against
page_count() is hopeless on THP subpages - they need to check
total_mapcount() against page_count() on THP heads only.

Make memfd_tag_pins() (compared > 1) as strict as memfd_wait_for_pins()
(compared != 1): either can be justified, but given the non-atomic
total_mapcount() calculation, it is better now to be strict.  Bear in
mind that total_mapcount() itself scans all of the THP subpages, when
choosing to take an XA_CHECK_SCHED latency break.

Also fix the unlikely xa_is_value() case in memfd_wait_for_pins(): if a
page has been swapped out since memfd_tag_pins(), then its refcount must
have fallen, and so it can safely be untagged.

Link: https://lkml.kernel.org/r/a4f79248-df75-2c8c-3df-ba3317ccb5da@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: Zeal Robot <zealci@zte.com.cn>
Reported-by: wangyong <wang.yong12@zte.com.cn>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: CGEL ZTE <cgel.zte@gmail.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Song Liu <songliubraving@fb.com>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 mm/shmem.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2689,7 +2689,8 @@ static void shmem_tag_pins(struct address_space *mapping)
 				slot = radix_tree_iter_retry(&iter);
 				continue;
 			}
-		} else if (page_count(page) - page_mapcount(page) > 1) {
+		} else if (!PageTail(page) && page_count(page) !=
+			   hpage_nr_pages(page) + total_mapcount(page)) {
 			radix_tree_tag_set(&mapping->page_tree, iter.index,
 					   SHMEM_TAG_PINNED);
 		}
@@ -2749,8 +2750,8 @@ static int shmem_wait_for_pins(struct address_space *mapping)
 				page = NULL;
 			}
 
-			if (page &&
-			    page_count(page) - page_mapcount(page) != 1) {
+			if (page && page_count(page) !=
+			    hpage_nr_pages(page) + total_mapcount(page)) {
 				if (scan < LAST_SCAN)
 					goto continue_resched;
 
