Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECCA166841
	for <lists+stable@lfdr.de>; Thu, 20 Feb 2020 21:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728958AbgBTUW4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Feb 2020 15:22:56 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:44677 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728556AbgBTUW4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Feb 2020 15:22:56 -0500
Received: by mail-il1-f196.google.com with SMTP id s85so24797793ill.11
        for <stable@vger.kernel.org>; Thu, 20 Feb 2020 12:22:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=g43zi0Kc4rp1x+vu6qU/MJPQUkT5VTc1y7CjnMTKB/U=;
        b=DxaOa9H9LsXwmVeUcdQ9a2a4Lx+1AEoRQm+cxsk/FaZxVs1YQwqkXI7AjFdbvv9Kn+
         NJIunjk6QvzzWAgEXLi0++42eecdwfZQc5vl+YKwnu4NU/RHtKpkQFK9L6g2KuWt1hOW
         RCN0wLy6+dIBia15/uRLf1XwwS5HwEPEsywENq5mVi35JW3EC1srSI4tk4nswAUNhJ0j
         IfIz3NixVjRiC+eVbeDd7yY3yTFNTzgU2dn00nZzQrhEh3LpzzCwByHW4Ew0TzeYxpWD
         /BjTsQrfY14WfDsK+Hf7MFDzLwa2hSM25QlcmhN3OTlsLoPtFK4t9ukFJ2yLdMVR1UeS
         7lkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=g43zi0Kc4rp1x+vu6qU/MJPQUkT5VTc1y7CjnMTKB/U=;
        b=Yxgmvgd03wMw+EKnXu/GphKyvnUA9csRBgJZPhxHLLfQ3YPKtiv++7wxvasN+nDwMr
         EkLLLWBmO3DpVaDoVpQ5xPHG6r3FPXeoq44ASFKY1EzCbxbGDxYVLXK1Enakt3t+aSzu
         ZpC/+cYlMk9IHnuh4rgrvVjD9KzEEGnzbLE4Q9vr9k/D4kXQEJsbeJab3CFES1TQHXWA
         XWEPAPa78EF4H6pjhErU1QBxstDxgpUZHsuKEx3xG985ASkU11d2TZK9kLIoSmUOrtL9
         XdVWOpgLTUD6AhiGeErazKu4DhMA+yIpEJ1tZi17CbCLPGSVF6P26SNDJjP+Synnt/29
         +i9A==
X-Gm-Message-State: APjAAAU8n7XSwueC7bP+2gARkHtCV3p7HEkw9ZE5iQbWs/vXXwkgEhCu
        EpoM5+L6qJMt8vz3UsEDrgO2bqtKwlFvidZMnQoj5Prb
X-Google-Smtp-Source: APXvYqyNuaplL0CRgFxpxvHvZUjqeUhgKd8v09MShHRL8DnQfTpresGrI6AdEogQfkeQ7PjxSJJZjicYnNlz2G89rVM=
X-Received: by 2002:a92:4a0a:: with SMTP id m10mr31992109ilf.84.1582230175748;
 Thu, 20 Feb 2020 12:22:55 -0800 (PST)
MIME-Version: 1.0
References: <20200102215518.148051-1-matthewgarrett@google.com> <20200104053108.B393D2071A@mail.kernel.org>
In-Reply-To: <20200104053108.B393D2071A@mail.kernel.org>
From:   Matthew Garrett <mjg59@google.com>
Date:   Thu, 20 Feb 2020 12:22:44 -0800
Message-ID: <CACdnJutSTAK8JA_dD9Mo_sNaZxK5GbUxa=xx7xrysh9gPqQNtw@mail.gmail.com>
Subject: Re: [PATCH V2] tpm: Don't make log failures fatal
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-integrity <linux-integrity@vger.kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 3, 2020 at 9:31 PM Sasha Levin <sashal@kernel.org> wrote:
>
> The bot has tested the following trees: v5.4.7, v5.3.18, v4.19.92, v4.14.=
161, v4.9.207, v4.4.207.
> v4.14.161: Failed to apply! Possible dependencies:
=E2=80=A6
> v4.9.207: Failed to apply! Possible dependencies:
=E2=80=A6
> v4.4.207: Failed to apply! Possible dependencies:
=E2=80=A6
> How should we proceed with this patch?

Ignoring these kernels should be fine.
