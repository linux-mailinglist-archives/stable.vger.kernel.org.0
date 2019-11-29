Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8BE10D73D
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 15:43:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbfK2Onz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 09:43:55 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:41090 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726808AbfK2Onz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Nov 2019 09:43:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575038634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=07R5CcsCDb5ZnoHBMkFPcMeVPYNSPLdNY/EmaEEXPCE=;
        b=E7Cbenw20SNzXJO+DIj8J1C1WBlV7L1VOWXIO8J9sMCA7Qv8ujDNOiAMCnj1T28Vt2XPgG
        4OWyKb02FAZko2id2VriaODBQg3ECFFL3xc7Ns3lwNHvVYNBhFAAdOA9YtMmDjEuSz3ehg
        +KXbAi6C5RFK2GUoilgkZiZ0pYXq/3E=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-17-0fzJ2KFaNGWUm6zbu2Yn9g-1; Fri, 29 Nov 2019 09:43:51 -0500
Received: by mail-il1-f199.google.com with SMTP id y3so20532999ilk.7
        for <stable@vger.kernel.org>; Fri, 29 Nov 2019 06:43:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WcxCZ1T6ObDD/o3DydMlzCp2J8NjBn+/A1S2bJY4dt0=;
        b=ZCDRCHWsukW3qCs8IKBH/ct3A3+AbELuA2ojFLVTHasSK8LrvwuxUNzUg0LHgOU9Pq
         UEjtPbBOMh2ZyIvKmkLJhP7ZE656vtIPKq6zX+PqSqNP65AppVbGLC04h79f8y33IIR6
         HJlFjwoNX+rUK1c2OdNmgbSWY0JuMifHtvKXSbGJnnzVzYCR+PF2BTbhtxtY9DNfL2KZ
         Ze2v88Grl74BOfXOZcfoN0+eeffoLnMC3UjMPbBTKsjKe5B3c4jepg2iNphHbLazul6/
         JWwUWVXrRY37dYwDRHwC1iPNhu6NPfBfDMzI4H/kHfVxdWu56VBKoU2xt4EPzj9N/ZAN
         zMLQ==
X-Gm-Message-State: APjAAAWIXrMu5lHXjtGDL4nxBm7u9qmOKqmohwtTkgngXaqJ4yARSJLq
        8+JdvorphKwSwKfDdtvSoGdj6jqs72LPhPyT0gCz5JLnj71aPhf/qnGKGznkgyPJnhZphdtaHly
        xtC75eszqNV0Y/zlXF0iWEZ4ts0vWhFhs
X-Received: by 2002:a92:c50c:: with SMTP id r12mr57822935ilg.255.1575038631023;
        Fri, 29 Nov 2019 06:43:51 -0800 (PST)
X-Google-Smtp-Source: APXvYqyBFGDa0xCe3lBviMI2n113cbZEg1EuEFb6kDHPyE0hDZL3+urbRr8OYAR+dvLz2owFoc/D4GdLqdlz/1iMGKs=
X-Received: by 2002:a92:c50c:: with SMTP id r12mr57822918ilg.255.1575038630861;
 Fri, 29 Nov 2019 06:43:50 -0800 (PST)
MIME-Version: 1.0
References: <20191128155940.17530-1-mszeredi@redhat.com> <20191128155940.17530-3-mszeredi@redhat.com>
 <8694f75f-e947-d369-6be3-b08287c381e9@redhat.com>
In-Reply-To: <8694f75f-e947-d369-6be3-b08287c381e9@redhat.com>
From:   Miklos Szeredi <mszeredi@redhat.com>
Date:   Fri, 29 Nov 2019 15:43:39 +0100
Message-ID: <CAOssrKccHtfwg4SYbQRwoaz_WcWJWNM3JXk7BHv=SPpsKOdkuQ@mail.gmail.com>
Subject: Re: [PATCH 02/12] fs_parse: fix fs_param_v_optional handling
To:     Andrew Price <anprice@redhat.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        stable <stable@vger.kernel.org>
X-MC-Unique: 0fzJ2KFaNGWUm6zbu2Yn9g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 29, 2019 at 12:31 PM Andrew Price <anprice@redhat.com> wrote:
>
> On 28/11/2019 15:59, Miklos Szeredi wrote:
> > String options always have parameters, hence the check for optional
> > parameter will never trigger.
> >
> > Check for param type being a flag first (flag is the only type that doe=
s
> > not have a parameter) and report "Missing value" if the parameter is
> > mandatory.
> >
> > Tested with gfs2's "quota" option, which is currently the only user of
> > fs_param_v_optional.
>
> It's not clear to me what the bug is here. My tests with the quota
> option are giving expected results. Perhaps I missed a case?

fsopen-test-2: fsconfig(3, FSCONFIG_SET_FLAG, "quota", NULL, 0):
Invalid argument
fsopen-test-2: context log: <e gfs2: Bad value for 'quota'>

kernel: 5.4.0-08836-g81b6b96475ac

Thanks,
Miklos

