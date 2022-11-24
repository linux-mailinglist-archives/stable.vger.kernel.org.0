Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8233636FE0
	for <lists+stable@lfdr.de>; Thu, 24 Nov 2022 02:31:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbiKXBbA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 20:31:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbiKXBa7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 20:30:59 -0500
X-Greylist: delayed 1122 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 23 Nov 2022 17:30:58 PST
Received: from out01.mta.xmission.com (out01.mta.xmission.com [166.70.13.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B053E7CB8A
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 17:30:58 -0800 (PST)
Received: from in01.mta.xmission.com ([166.70.13.51]:34004)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <dominic@xmission.com>)
        id 1oy0mk-007OyU-5M; Wed, 23 Nov 2022 18:12:14 -0700
Received: from 75-169-132-183.slkc.qwest.net ([75.169.132.183]:53660 helo=mail.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <dominic@xmission.com>)
        id 1oy0mh-00FDCX-4S; Wed, 23 Nov 2022 18:12:13 -0700
Date:   Thu, 24 Nov 2022 01:08:57 +0000
Message-ID: <709b163021b2608789dab55eb3f9724c.dominic@xmission.com>
From:   Dominic Jones <jonesd@xmission.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev
Content-Type: text/plain
X-XM-SPF: eid=1oy0mh-00FDCX-4S;;;mid=<709b163021b2608789dab55eb3f9724c.dominic@xmission.com>;;;hst=in01.mta.xmission.com;;;ip=75.169.132.183;;;frm=dominic@xmission.com;;;spf=pass
X-XM-AID: U2FsdGVkX19V0hpdjZAJ12wd0swbngZP
X-SA-Exim-Connect-IP: 75.169.132.183
X-SA-Exim-Mail-From: dominic@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Greg KH <gregkh@linuxfoundation.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 2511 ms - load_scoreonly_sql: 0.07 (0.0%),
        signal_user_changed: 14 (0.5%), b_tie_ro: 11 (0.5%), parse: 1.18
        (0.0%), extract_message_metadata: 46 (1.8%), get_uri_detail_list: 4.6
        (0.2%), tests_pri_-1000: 44 (1.8%), tests_pri_-950: 1.41 (0.1%),
        tests_pri_-900: 1.08 (0.0%), tests_pri_-200: 0.90 (0.0%),
        tests_pri_-100: 12 (0.5%), tests_pri_-90: 154 (6.1%), check_bayes: 104
        (4.2%), b_tokenize: 8 (0.3%), b_tok_get_all: 10 (0.4%), b_comp_prob:
        3.3 (0.1%), b_tok_touch_all: 78 (3.1%), b_finish: 1.20 (0.0%),
        tests_pri_0: 283 (11.3%), check_dkim_signature: 0.57 (0.0%),
        check_dkim_adsp: 11 (0.4%), poll_dns_idle: 1899 (75.6%), tests_pri_10:
        4.4 (0.2%), tests_pri_500: 1944 (77.4%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [REGRESSION] v6.0.x fails to boot after updating from v5.19.x
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On Fri, Oct 28, 2022 at 02:51:43PM +0000, Dominic Jones wrote:
> > Updating the machine's kernel from v5.19.x to v6.0.x causes the machine to not
> > successfully boot. The machine boots successfully (and exhibits stable operation)
> > with version v5.19.17 and multiple earlier releases in the 5.19 line. Multiple releases
> > from the 6.0 line (including 6.0.0, 6.0.3, and 6.0.5), with no other changes to the
> > software environment, do not boot. Instead, the machine hangs after loading services
> > but before presenting a display manager; the machine instead shows repetitive hard
> > drive activity at this point and then no apparent activity.
> > 
> > ''uname'' output for the machine successfully running v5.19.17 is:
> > 
> >     Linux [MACHINE_NAME] 5.19.17 #1 SMP PREEMPT_DYNAMIC Mon Oct 24 13:32:29 2022 i686 Intel(R) Atom(TM) CPU N270 @ 1.60GHz GenuineIntel GNU/Linux
> > 
> > The machine is an OCZ Neutrino netbook, running a custom OS build largely similar to
> > LFS development. The kernel update uses ''make olddefconfig''.
> 
> Can you use 'git bisect' to find the offending change that causes this
> to happen?

Bisection is complete. Here's what it returned.

---

3a194f3f8ad01bce00bd7174aaba1563bcc827eb is the first bad commit
commit 3a194f3f8ad01bce00bd7174aaba1563bcc827eb
Author: Naoya Horiguchi <naoya.horiguchi@nec.com>
Date:   Thu Jul 14 13:24:14 2022 +0900

    mm/hugetlb: make pud_huge() and follow_huge_pud() aware of non-present pud entry
    
    follow_pud_mask() does not support non-present pud entry now.  As long as
    I tested on x86_64 server, follow_pud_mask() still simply returns
    no_page_table() for non-present_pud_entry() due to pud_bad(), so no severe
    user-visible effect should happen.  But generally we should call
    follow_huge_pud() for non-present pud entry for 1GB hugetlb page.
    
    Update pud_huge() and follow_huge_pud() to handle non-present pud entries.
    The changes are similar to previous works for pud entries commit
    e66f17ff7177 ("mm/hugetlb: take page table lock in follow_huge_pmd()") and
    commit cbef8478bee5 ("mm/hugetlb: pmd_huge() returns true for non-present
    hugepage").
    
    Link: https://lkml.kernel.org/r/20220714042420.1847125-3-naoya.horiguchi@linux.dev
    Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
    Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
    Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
    Cc: David Hildenbrand <david@redhat.com>
    Cc: kernel test robot <lkp@intel.com>
    Cc: Liu Shixin <liushixin2@huawei.com>
    Cc: Muchun Song <songmuchun@bytedance.com>
    Cc: Oscar Salvador <osalvador@suse.de>
    Cc: Yang Shi <shy828301@gmail.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

 arch/x86/mm/hugetlbpage.c |  8 +++++++-
 mm/hugetlb.c              | 32 ++++++++++++++++++++++++++++++--
 2 files changed, 37 insertions(+), 3 deletions(-)

---

Dominic
