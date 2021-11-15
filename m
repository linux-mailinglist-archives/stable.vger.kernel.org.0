Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2E1452572
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239607AbhKPBv0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:51:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240615AbhKOSQB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 13:16:01 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64B86C034019
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 09:39:55 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id v7-20020a25ab87000000b005c2130838beso27958674ybi.0
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 09:39:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=g8n3dntLdVor/bCGUEahQ0hpXTWGo9L1uMnZI0pRNmw=;
        b=b4UiZIE2IKFJ/TQXUJPvWTT2u+0GyenaJBmDTr/JRIJaTZw4Mphygxi+AAJ05/Zvc4
         3Ih6X9J9jDdFrdtK4MMNS7USolcWjLOmbDZfxW+38KAO2Pf4nKYDTPbECwjtkOA4tBVA
         /m2IhEXu2vlmAODL91Tr/0cZwMmD8mRRhXU6KQsZn0wdXRus3LN2GLY+ronOA6mLh3TO
         +AywSm25OOW+v4wPk1WWIvwjIVl7w3YwDwfUBPDUnpEt0fUpRLNF6wIkpLCt3D6s334o
         hwgrJ6Gu0SLXD6lNFo3QEVySDnoap+YaDUeTtZMiv0bL6iGOFNi0Sv4xoMHXZZxVrA1G
         Ayhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=g8n3dntLdVor/bCGUEahQ0hpXTWGo9L1uMnZI0pRNmw=;
        b=DNYOj3SrH9f5wTTF2tg5UDIJkvSrm0/xgGksyc66DOLI0O5MOEdBDCo7gWPyLyAQ+9
         SCTj9HAyu26I50bdFTIg8vdwNGvPHc87nyhgYCMjE7WYOIpqSksw70twR6eWXWuIWNch
         e1U1he0feWCAPTNA21OA7jBlMQzoQep4X/xklE76SxC8R76IehLPvPe0I6pNqE/a/s4Z
         qIjuqpUqnYDxFKQLB/gO+z23dTI2/kJuiYy2UXXCO2/FJ505XPYIIJqxprPMIwUK5Qkt
         2NGVW+kFJ+LzoH3tstc8miO0j8M5FGZ2yhmpGLwkNwniu7Du669t5dfCwjo3R2UbAsWn
         nu2g==
X-Gm-Message-State: AOAM532uBusZv7gKxY4gaKjUrPu7VkAhr8E+WepXRlFoN7evxc1NdnRO
        8Z3Do69Ic3046etm8iWez91pzJST7SmiVKmbm6bWrNncGpsZTVG8Kuc5g9EpWVKDnEXFReE5X88
        jzxaxRQjbgmJsYO3TnwCdfZg0QaikqkqF9OMIARKo/2dvJeom0p+jKJGXcc6Xt8Iu
X-Google-Smtp-Source: ABdhPJzGmNcB85YZZUc9hopOicjmkKWG6Y5gfSclL87IiWkfWGa+5Qq3L9uYEyzdjqMzySsVqS4/zFei6+sI
X-Received: from gthelen2.svl.corp.google.com ([2620:15c:2cd:202:9bec:4456:32fe:aeb8])
 (user=gthelen job=sendgmr) by 2002:a25:69c1:: with SMTP id
 e184mr686445ybc.235.1636997994642; Mon, 15 Nov 2021 09:39:54 -0800 (PST)
Date:   Mon, 15 Nov 2021 09:39:53 -0800
Message-Id: <xr9335nxwc5y.fsf@gthelen2.svl.corp.google.com>
Mime-Version: 1.0
Subject: STABLE REQUEST: perf/core: Avoid put_page() when GUP fails
From:   Greg Thelen <gthelen@google.com>
To:     stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <ak@linux.intel.com>,
        Kan Liang <kan.liang@intel.com>,
        Stephane Eranian <eranian@google.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch titled ("perf/core: Avoid put_page() when GUP fails") has been
merged into linus/master as commit
4716023a8f6a0f4a28047f14dd7ebdc319606b84.

The patch fixes an issue present in all v4.14+ kernels that can cause
page reference count underflow, which can lead to unintentional page
sharing.

The patch did not have cc: stable footer, so I'm manually requesting
-stable inclusion into v4.14+.

There are some trivial conflicts in older kernels. I'd be happy to
review/test, if that's useful.
