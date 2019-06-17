Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D50848CEE
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 20:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727409AbfFQSud (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 14:50:33 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:41837 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbfFQSud (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jun 2019 14:50:33 -0400
Received: by mail-lf1-f68.google.com with SMTP id 136so7314835lfa.8
        for <stable@vger.kernel.org>; Mon, 17 Jun 2019 11:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pJNgLRxBBn3ldusAk8vZnHSv/cw7OZUcPpU87Ds7axA=;
        b=Bou8DRGEQCecEBNSUfFtTPeseoLHD0XaAFEIBsWSO0ipikvw3uK03pajREfMRg9xGJ
         RHjbeoD4wiwvH1jw+HHfdArE6k8zcfMKGxTOigVfiqDD3yQNYZV/bHc7sTIEHfVYs6/a
         BFygJ9Og1NqRb3jOobPB1z9rLh9rBzkbN9K0k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pJNgLRxBBn3ldusAk8vZnHSv/cw7OZUcPpU87Ds7axA=;
        b=UNRFuDBfq5InYkdZVtEGXoJR2G9IhME65UjKkW7kycKgbsEZsV6zKqByvHPEOKfkSo
         6PRfgrxRBf2T2pH/M0eWi8Qj+JbNPrpUSYj8h95SjW7qmgRPELkJqh3qYuPGoaZIYCk8
         QLWCDpi0+e4dYPrLZNemlzfihmksAuig1K1DTlyugDVTWc57bVqkXCr6Bq8OzVsvieK5
         +lozXSJdTInEivAPCM6+KLE3EFvwWB8Rjw1CJyMiaFD8JtSTrconRVThYLB/Ax+SfoxM
         rIWlV32/w4n8wAeS79lYB7PYhNfRXERXNSJrOiGYdE3CJBFL5JRU9L8ct2t29XREvTrw
         yX8w==
X-Gm-Message-State: APjAAAWf7VBqN8SRwP3vFKiC3fT8dko/bxk1PFOr3kpd+XOdHKGhOQwg
        3u43bpJYVuG8k0V3w1dJW872+IbIyKc=
X-Google-Smtp-Source: APXvYqwWiWjm9xCYMO0eJij13TgSPgDMK9ajjbQqqog4Z+63hRWG81IyNDnwqahQXLCrhcQ+JmSnsw==
X-Received: by 2002:ac2:44c5:: with SMTP id d5mr6892648lfm.134.1560797430811;
        Mon, 17 Jun 2019 11:50:30 -0700 (PDT)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com. [209.85.208.182])
        by smtp.gmail.com with ESMTPSA id e14sm1842813lfd.84.2019.06.17.11.50.30
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 11:50:30 -0700 (PDT)
Received: by mail-lj1-f182.google.com with SMTP id m23so10336013lje.12
        for <stable@vger.kernel.org>; Mon, 17 Jun 2019 11:50:30 -0700 (PDT)
X-Received: by 2002:a2e:9a58:: with SMTP id k24mr14840250ljj.165.1560797429770;
 Mon, 17 Jun 2019 11:50:29 -0700 (PDT)
MIME-Version: 1.0
References: <20190617184711.21364-1-christian@brauner.io>
In-Reply-To: <20190617184711.21364-1-christian@brauner.io>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 17 Jun 2019 11:50:13 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh+OWQ2s-NZC4RzfHtgNfhV9sbtP6dXV4WnsVRQ3A3hnA@mail.gmail.com>
Message-ID: <CAHk-=wh+OWQ2s-NZC4RzfHtgNfhV9sbtP6dXV4WnsVRQ3A3hnA@mail.gmail.com>
Subject: Re: [PATCH] fs/namespace: fix unprivileged mount propagation
To:     Christian Brauner <christian@brauner.io>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 17, 2019 at 11:47 AM Christian Brauner <christian@brauner.io> wrote:
>
> When propagating mounts across mount namespaces owned by different user
> namespaces it is not possible anymore to move or umount the mount in the
> less privileged mount namespace.

I will wait a short while in the hope of getting Al's ack for this,
but since it looks about as good as it likely can be, I suspect I'll
just apply it later today even without such an ack..

                    Linus
