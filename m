Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCA626C93A2
	for <lists+stable@lfdr.de>; Sun, 26 Mar 2023 11:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbjCZJrT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 26 Mar 2023 05:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231840AbjCZJrS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Mar 2023 05:47:18 -0400
Received: from eggs.gnu.org (eggs.gnu.org [IPv6:2001:470:142:3::10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94BE872B7
        for <stable@vger.kernel.org>; Sun, 26 Mar 2023 02:47:16 -0700 (PDT)
Received: from linux-libre.fsfla.org ([209.51.188.54] helo=free.home)
        by eggs.gnu.org with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        (envelope-from <oliva@gnu.org>)
        id 1pgMxw-0007yn-JQ; Sun, 26 Mar 2023 05:47:08 -0400
Received: from livre (livre.home [172.31.160.2])
        by free.home (8.15.2/8.15.2) with ESMTPS id 32Q9kqhG1381859
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Sun, 26 Mar 2023 06:46:54 -0300
From:   Alexandre Oliva <oliva@gnu.org>
To:     John Harrison <john.c.harrison@intel.com>
Cc:     <intel-gfx@lists.freedesktop.org>, <stable@vger.kernel.org>
Subject: Re: [Intel-gfx] [PATCH] [i915] avoid infinite retries in GuC/HuC loading
Organization: Free thinker, not speaking for the GNU Project
References: <orjzzlhhg8.fsf@lxoliva.fsfla.org>
        <b9a2746f-bace-3a1e-eb82-8e8eecddb6ae@intel.com>
Date:   Sun, 26 Mar 2023 06:46:24 -0300
In-Reply-To: <b9a2746f-bace-3a1e-eb82-8e8eecddb6ae@intel.com> (John Harrison's
        message of "Fri, 24 Mar 2023 11:45:07 -0700")
Message-ID: <or1qlbvo9b.fsf@lxoliva.fsfla.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.84
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello, John,

On Mar 24, 2023, John Harrison <john.c.harrison@intel.com> wrote:

> On 3/12/2023 12:56, Alexandre Oliva wrote:
>> If two or more suitable entries with the same filename are found in
>> __uc_fw_auto_select's fw_blobs, and that filename fails to load in the
>> first attempt and in the retry, when __uc_fw_auto_select is called for
>> the third time, the coincidence of strings will cause it to clear
>> file_selected.path at the first hit, so it will return the second hit
>> over and over again, indefinitely.
>> 
>> Of course this doesn't occur with the pristine blob lists, but a
>> modified version could run into this, e.g., patching in a duplicate
>> entry, or (as in our case) disarming blob loading by remapping their
>> names to "/*(DEBLOBBED)*/", given a toolchain that unifies identical
>> string literals.
> Not sure what you mean by disarming?

Our users find loading nonfree firmware harmful.

> I think what you are saying is that you made a change similar to this?
>     #define __MAKE_UC_FW_PATH_MMP(prefix_, name_, major_, minor_,
> patch_) "i915/invalid_file_name.bin"

Yeah, that's the jist of it.  The name we use is "/*(DEBLOBBED)*/", so
that it can't possibly be satisfied.

> So all entries in the table have the exact same filename.

*nod*

> And with the toolchain unification comment, that means not just a
> matching string but the same string pointer. Thus, the search code is
> getting confused.

Exactly

> I'm not sure that is really a valid use case that the driver code
> should be expected to support.

It's most certainly not.  As I wrote, I'd be happy to keep on carrying
the patch that adjusts the code to cope with our changes.  I just
thought the same issue could come up by, say, mistakenly applying a
patch twice to add support for a new card, a circumstance in which one
might not have the card readily available to try it out.

> Even without the infinite loop, the driver is not
> going to load because you have removed the firmware files?

Oh, no, the driver loads just fine even without those blobs, and that's
much nicer of you than other drivers for hardware that doesn't really
require blobs, but that insist on bailing out if the firmware can't be
loaded.  i915 hasn't been hostile like that.

When you override the firmware filenames, and it fails to load, the
driver makes it a (reasonable IMHO) hard fail, but when it just fails to
find the regular firmware files, it's nice that it proceeds that does
the best it can.

> However, I think you are saying that the problem would also exist if
> there was some kind of genuine duplication in the table?

Yes.  Not the kind you mention, for different platforms, but an actual
duplicate entry, such as what you might get if you applied a patch that
added an entry for a new card, and then applied it again, resolving the
conflicts in a way that retained the duplicate entries.

> So there can only be a problem if a single platform specifies the same
> filename multiple times? Which would be a bug in the table because
> why? It would be redundant entries that have no purpose.

Agreed.

> Note that I'm not saying we don't want to take your change. But I
> would like to understand if there is a genuine issue that maybe needs
> a better fix. E.g. should the table verification code be enhanced to
> just reject the table entirely if there are such errors present.

Table verification might wish to detect and report duplicate filenames
for the same platform, to catch even alternating duplicates (e.g. "a",
then "b", then "a" again), but it would be kind if you didn't make that
a hard error, otherwise we'd have to tweak it to cope with our own
"/*(DEBLOBBED)*/" duplicates.

Another approach, that would probably be more efficient as the table
grows, is to store in uc_fw a pointer to or index of the current or next
entry to be searched, so that the code doesn't have to iterate over the
table at every try (O(n^2)), and instead takes it from exactly where it
left off, running overall a single time over the whole table (O(n)), at
the cost of a pointer or index in uc_fw.  Then, duplicates in the table
wouldn't matter at all.

> Also, is this string unification thing a part of the current gcc
> toolchain?

Yeah, compilers and linkers have been unifying (read-only) string
literals for a very long time.

Thanks,

-- 
Alexandre Oliva, happy hacker                https://FSFLA.org/blogs/lxo/
   Free Software Activist                       GNU Toolchain Engineer
Disinformation flourishes because many people care deeply about injustice
but very few check the facts.  Ask me about <https://stallmansupport.org>
