Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8B734BB07F
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 05:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbiBREGH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 23:06:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiBREGH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 23:06:07 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 864E955751
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 20:05:51 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id w1so6200172plb.6
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 20:05:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=HhZ+gUX30hM17AylnTVI1rNaaPl74E0Ggeyqli65+jw=;
        b=nV/wLVqj16n/UUibEktm9eHsmp7NC73nSrQEkzT9CZG8bVQ2mCx2rwfWP/wNrdwOCe
         C0QHlpPDMPH92D7zn1UxkTsCvR4jQj+Sr6niQNGt2Nz2LOfGrmhk82mVFtPEZ7kndrHL
         31XglZl+RdjwxUtM61yK5y6oM5crpexIoklCoMzBUHviWZUTXZsR9a/N+AiF1G261aaw
         LykKHEkRzHCbb8frgcnFJldEo+3xEbCyChRg5FX9GX5XG3KyPJ/DALFL6unFc17WnedZ
         6j8LfsV0SIj83N8VZLE1kM8wkuDaZwBhUtFp6YF1287n37cPm8yJ9K/WCw701O4/KzB7
         bVXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=HhZ+gUX30hM17AylnTVI1rNaaPl74E0Ggeyqli65+jw=;
        b=T/3+kpCJedR0WuHbnLMEN2v4zhzPZa0nYsH9jN0hZ8u3rhQtDN1DZcp3TphG/5owyV
         kKRKRmk1ZpdR2C4/A4OlrdGT+obVKYHOrypKybkpIJ2JQLXpashgnbftsCBj5b64piG1
         cCofv0+QJwV4vs1jWFPbvT2zy3hCo1ecEOVAKJ3R+mVfVAWWk/pqY7iV15L+/usp2b1I
         QI6XYyGnf13Nzp+TPOfweZ3XbEsCiZ+2p5mCOELao7hR71urPS34Wy5YA5C36rqyYufm
         qxx77Y3DN5H3HA1K0NCIpEu+QcPc28atuyVV3fzjJoIbo4QDHRwB1Im9oSNKgSrbpGx9
         fGaQ==
X-Gm-Message-State: AOAM532/5gQmx+assSNv9aak8WzNrqmO8g2g7v+tYgFGGXiuOiWydROq
        0kjJ0M3NM0JucutDzXIAm9c=
X-Google-Smtp-Source: ABdhPJyoLwCYZ4uByLJN3/vT1bKkSrVVe/k/ceQZNy0crerUR69DMV7awuHutF6G8WFIoLF+Li4RQA==
X-Received: by 2002:a17:90b:314e:b0:1b9:ef8b:d441 with SMTP id ip14-20020a17090b314e00b001b9ef8bd441mr10663313pjb.215.1645157150906;
        Thu, 17 Feb 2022 20:05:50 -0800 (PST)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id j15sm1117734pfj.102.2022.02.17.20.05.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Feb 2022 20:05:50 -0800 (PST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.40.0.1.81\))
Subject: Re: [PATCH] userfaultfd: mark uffd_wp regardless of VM_WRITE flag
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <68B04C0D-F8CE-4C95-9032-CF703436DC99@gmail.com>
Date:   Thu, 17 Feb 2022 20:05:49 -0800
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>, stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <3E9C755C-7335-4636-8280-D5CB9735A76A@gmail.com>
References: <20220217211602.2769-1-namit@vmware.com>
 <Yg79WMuYLS1sxASL@xz-m1.local>
 <BDBC90F4-22E1-48CC-9DB8-773C044F0231@gmail.com>
 <68B04C0D-F8CE-4C95-9032-CF703436DC99@gmail.com>
To:     Peter Xu <peterx@redhat.com>
X-Mailer: Apple Mail (2.3693.40.0.1.81)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Feb 17, 2022, at 8:00 PM, Nadav Amit <nadav.amit@gmail.com> wrote:
>=20
>=20
>> On Feb 17, 2022, at 6:23 PM, Nadav Amit <nadav.amit@gmail.com> wrote:
>>=20
>>> PS: I always think here the VM_SOFTDIRTY check is wrong, IMHO it =
should be:
>>>=20
>>>      if (dirty_accountable && pte_dirty(ptent) &&
>>>                      (pte_soft_dirty(ptent) ||
>>>                      (vma->vm_flags & VM_SOFTDIRTY))) {
>>>              ptent =3D pte_mkwrite(ptent);
>>>      }
>=20
> I know it is off-topic (not directly related to my patch), but
> I tried to understand the logic - both of the existing code and of
> your suggested change - and I failed.
>=20
> IIUC dirty_accountable (whose value is taken from
> vma_wants_writenotify()) means that the writes *should* be tracked,
> and therefore the page should remain read-only.
>=20
> So basically the condition should have been based on
> !dirty_accountable, i.e. the inverted value of dirty_accountable.
>=20
> The problem is that dirty_accountable also reflects VM_SOFTDIRTY
> considerations, so looking on the PTE does not tell you whether
> the PTE should remain write-protected even if it is dirty.

Just as I pressed send, I understood your suggestion.

It is still confusing for me how setting write-permissions for
dirty_accountable PTEs is safe (as long as they are dirty), and
yet in the general case it is not safe. I need to further think
of it.=
