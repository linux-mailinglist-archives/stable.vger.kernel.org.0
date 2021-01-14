Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AAE52F5B5F
	for <lists+stable@lfdr.de>; Thu, 14 Jan 2021 08:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbhANHdj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jan 2021 02:33:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbhANHdj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jan 2021 02:33:39 -0500
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92796C061794;
        Wed, 13 Jan 2021 23:32:58 -0800 (PST)
Received: by mail-qk1-x729.google.com with SMTP id z11so6180251qkj.7;
        Wed, 13 Jan 2021 23:32:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YluTp1iiC4qK4Zr758wnPdW/p9IlI0aWMEdgx+CBnY0=;
        b=IHPl9EqawBrLzdqgHRmShS6uq4OHTiMefYeV0VN9fm8X1a+IGfICxYMUKepAoj16c3
         Pk1sUoDjbMby8Yyoou4oPorWTa+MHmx6LyHkALDsL2g1HOADU4LBn/mQxtlCIgYMZCKc
         oE/Eah27Wh2l8qb7AQle6achSlApYVfS/mLWo1D1Iv7YTiGeTescwiay0itj55vZvIhJ
         CiFSJNqu83LG7adNhFLjEDlVyZo5X2eOoa+cgAbHW0MkN3USj54irN+TM5SCSV2F8XbK
         LXWbu6TH7tDM6oab1UQhOn/zGvT8JYvdC0lXQ8oREHqI7iYlGEFfM+TCHyQ3YY3apPVw
         W5Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YluTp1iiC4qK4Zr758wnPdW/p9IlI0aWMEdgx+CBnY0=;
        b=jq+Y4l78+UBnd0ufhSR7AztUbUxGK+qQO4JEb3j3Q7IZHdxisF3soCgNK7JHVUijAB
         9Xy2RTQVRRbuSOq0ScSnlba3/HTp6K+C2/4PMI9s5WJPVemlmzgO7EkxfROm2CpY902r
         cfpGI9StxDi137h1B7qttsFOH6rrsy0QAT+Mcr2v6JDKofZkczzuA7YUQv2MmLoP5KUc
         aAM4gp15f504v0PanjmZfBW9sHP+NxeasinRxJ/YrsyBy92L9+WaxVIijNLCNkKPdOqD
         i8euqrHAXFMV1087i7C54LVyB9h5dNkpFUsCK7X5SWzK4s6ZYEmav1fHVlrU3uK7nqlH
         IUlA==
X-Gm-Message-State: AOAM531dlqEEgjURKBZJGo953yh9ub/ItJoNUvFhKc6CziUM6iwDSiuc
        k/esNAFvnbOmtWnEuSZIbJsaza0BBIFKKHRUsVU=
X-Google-Smtp-Source: ABdhPJwsFDL41WRD/AAFiY/z7zxaMXRJZSK3cEAdBYilL7w8Bh7kISXiUa9N9GKMcClfjQqwvv0zwA9WrU5h8QtpD6Y=
X-Received: by 2002:a05:6902:20a:: with SMTP id j10mr9082339ybs.293.1610609577685;
 Wed, 13 Jan 2021 23:32:57 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5msvYs4nLbje4vP+XNF_7SR=b5QehQ=t1WT4o=Ki6imPxg@mail.gmail.com>
 <20210113171616.11730-1-pc@cjr.nz> <CAKywueSoG8zCqmVgaOtvG5AM4fi47+bFJ3VdHPAa=sJa+v2duA@mail.gmail.com>
In-Reply-To: <CAKywueSoG8zCqmVgaOtvG5AM4fi47+bFJ3VdHPAa=sJa+v2duA@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Thu, 14 Jan 2021 13:02:46 +0530
Message-ID: <CANT5p=pBS9=Dd+=1dEtfV_9=reVgMqRcpv7rODxm6e8K3xBPOg@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix interrupted close commands
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     Paulo Alcantara <pc@cjr.nz>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Duncan Findlay <duncf@duncf.ca>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Paulo,

Does is_interrupt_error contain a list of all errors for which server
can leave the file handle open?
What about EAGAIN? I see that the server error STATUS_RETRY maps to EAGAIN.

Regards,
Shyam

On Thu, Jan 14, 2021 at 12:01 AM Pavel Shilovsky <piastryyy@gmail.com> wrot=
e:
>
> =D1=81=D1=80, 13 =D1=8F=D0=BD=D0=B2. 2021 =D0=B3. =D0=B2 09:16, Paulo Alc=
antara <pc@cjr.nz>:
> >
> > Retry close command if it gets interrupted to not leak open handles on
> > the server.
> >
> > Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> > Reported-by: Duncan Findlay <duncf@duncf.ca>
> > Suggested-by: Pavel Shilovsky <pshilov@microsoft.com>
> > Fixes: 6988a619f5b7 ("cifs: allow syscalls to be restarted in __smb_sen=
d_rqst()")
> > Cc: stable@vger.kernel.org
> > ---
> >  fs/cifs/smb2pdu.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> > index 067eb44c7baa..794fc3b68b4f 100644
> > --- a/fs/cifs/smb2pdu.c
> > +++ b/fs/cifs/smb2pdu.c
> > @@ -3248,7 +3248,7 @@ __SMB2_close(const unsigned int xid, struct cifs_=
tcon *tcon,
> >         free_rsp_buf(resp_buftype, rsp);
> >
> >         /* retry close in a worker thread if this one is interrupted */
> > -       if (rc =3D=3D -EINTR) {
> > +       if (is_interrupt_error(rc)) {
> >                 int tmp_rc;
> >
> >                 tmp_rc =3D smb2_handle_cancelled_close(tcon, persistent=
_fid,
> > --
> > 2.29.2
> >
>
> Thanks for the fix!
>
> Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
>
> --
> Best regards,
> Pavel Shilovsky



--=20
-Shyam
