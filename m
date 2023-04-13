Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4CBE6E1885
	for <lists+stable@lfdr.de>; Fri, 14 Apr 2023 01:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbjDMX67 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Apr 2023 19:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbjDMX66 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Apr 2023 19:58:58 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC0AD3C06
        for <stable@vger.kernel.org>; Thu, 13 Apr 2023 16:58:57 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1a273b3b466so251655ad.1
        for <stable@vger.kernel.org>; Thu, 13 Apr 2023 16:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681430337; x=1684022337;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EefSkyZ3Lf0FxAAlOktzH9a+rP5j/aHtRq9oKYJfYbo=;
        b=a3byag42DLwFJ6SRJEJQ1CcOmIM/nt97jvXvLVycLr+Vz6t8EuDD3sfm40CDOIf2l+
         CWnXHMfEZ9X0fhqgtzPG+zqEGL/DmRKb5uFzisQdqhsMYKi2FTj6pW25nSR9jIv/TrhH
         d0sv/sposQqbLpPuM9L+y+vBg8xN8XjARVzLMSSMPrKJJVxX9Na1q0mDetHv8ISLhI1H
         Fxc1ejXe8TUp1biTe/A2rKuRtETHTzgVp6Btl5QXZCzGmH6p0qWTIIYYZBj3a+tjVq5H
         dSl9te0h/slqxMAmE/8u+tC+ViHh/1jJrqttvZd2/SAl8mgV5eT9eYY1Ywf8DluAngIb
         JgQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681430337; x=1684022337;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EefSkyZ3Lf0FxAAlOktzH9a+rP5j/aHtRq9oKYJfYbo=;
        b=CGN4eTNz01FtX1a6c1zMeAKs82HvYfsuKGADCl8MEQNFf0DxYlh/9whsxZN9xRndHV
         81n1qdfKm7wq36qcc0R2iCSnV9GLCz1XuTntRlFgtLGNLQIdiVYLhX9KkGhSkCQEuLGP
         MUWkIGVOWv2Zqf7V+KlA5S1ntZJLcuHjShNbVJHgZOdvRmo0SF0RkChHh+k1RjkQuTQP
         XzRDgsaonVwn8REtFwNY6L7GLqWzhOAkUe3tLNhSH7kRbrWqNzLyKNWwyhEoMvMk1eua
         Rwwt8scuZvOHNB+4aYl9EO/QAa3UPw6NSkfEkF191+P2dcc2Ch8+Ss6h0LPmnl8GtPso
         K0qg==
X-Gm-Message-State: AAQBX9dFrRHfCMGJ485immwk05YclXnrjApBfnDSSB3HN63JKua8uy5H
        wtffGU3amJXRAOQf3CfMXLtzug==
X-Google-Smtp-Source: AKy350YH5HIo+Pnar7dEHZwI83HNlquD0aFwYwkXZ4qi+fngzr+A7Sa4LTPVo1hWYWBDnD1pMLkLMQ==
X-Received: by 2002:a17:902:d546:b0:19c:c5d4:afd2 with SMTP id z6-20020a170902d54600b0019cc5d4afd2mr28099plf.11.1681430336852;
        Thu, 13 Apr 2023 16:58:56 -0700 (PDT)
Received: from [2620:0:1008:11:dd63:9ab7:90b4:a420] ([2620:0:1008:11:dd63:9ab7:90b4:a420])
        by smtp.gmail.com with ESMTPSA id k14-20020aa792ce000000b0062e15c22cd8sm1901961pfa.48.2023.04.13.16.58.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 16:58:56 -0700 (PDT)
Date:   Thu, 13 Apr 2023 16:58:55 -0700 (PDT)
From:   David Rientjes <rientjes@google.com>
To:     Yang Shi <shy828301@gmail.com>, willemb@google.com
cc:     David Hildenbrand <david@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        kirill.shutemov@linux.intel.com, jannh@google.com,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [v4 PATCH] fs/proc: task_mmu.c: don't read mapcount for migration
 entry
In-Reply-To: <CAHbLzkp16tAzFRnM3BUnspnR-qR2JG3c9TqaNq3YHxy9u5ZC6w@mail.gmail.com>
Message-ID: <67d3e5e1-57be-590d-f925-47b49442a67e@google.com>
References: <20220203182641.824731-1-shy828301@gmail.com> <132ba4a4-3b1d-329d-1db4-f102eea2fd08@suse.cz> <9ba70a5e-4e12-0e9f-a6a4-d955bf25d0fe@redhat.com> <64ec7939-0733-7925-0ec0-d333e62c5f21@suse.cz> <CAHbLzkoZctsJf92Lw3wKMuSqT7-aje0SiAjc6JVW5Z3bNS1JNg@mail.gmail.com>
 <efab25ef-c29c-3671-5f26-060bba76d481@suse.cz> <CAHbLzkomXCwabFrNaNyuGBozmindHqVD0ki4n75XJ2V8Uw=9rw@mail.gmail.com> <5618f454-7a88-0443-59e7-df9780e9fa50@redhat.com> <CAHbLzkp16tAzFRnM3BUnspnR-qR2JG3c9TqaNq3YHxy9u5ZC6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="2003089352-1481215759-1681430336=:63269"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--2003089352-1481215759-1681430336=:63269
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Mon, 3 Apr 2023, Yang Shi wrote:

> On Mon, Apr 3, 2023 at 12:30 AM David Hildenbrand <david@redhat.com> wrote:
> >
> > On 24.03.23 21:12, Yang Shi wrote:
> > > On Fri, Mar 24, 2023 at 4:25 AM Vlastimil Babka <vbabka@suse.cz> wrote:
> > >>
> > >> On 3/23/23 21:45, Yang Shi wrote:
> > >>> On Thu, Mar 23, 2023 at 3:11 AM Vlastimil Babka <vbabka@suse.cz> wrote:
> > >>>
> > >>> Out of curiosity, is there any public link for this CVE? Google search
> > >>> can't find it.
> > >>
> > >> Only this one is live so far, AFAIK
> > >>
> > >> https://bugzilla.redhat.com/show_bug.cgi?id=2180936
> > >
> > > Thank you.
> >
> > There is now
> >
> > https://access.redhat.com/security/cve/cve-2023-1582
> 
> Thank you.
> 

Hi Yang,

commit 24d7275ce2791829953ed4e72f68277ceb2571c6
Author: Yang Shi <shy828301@gmail.com>
Date:   Fri Feb 11 16:32:26 2022 -0800

    fs/proc: task_mmu.c: don't read mapcount for migration entry

is backported to 5.10 stable but not to 5.4 or earlier stable trees.  The 
commit advertises to fix a commit from 4.5.

Do we need stable backports for earlier trees or are they not affected?

Thanks!
--2003089352-1481215759-1681430336=:63269--
