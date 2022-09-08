Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF465B1C1D
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 14:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbiIHMCz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 08:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiIHMCy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 08:02:54 -0400
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2773EE22A0;
        Thu,  8 Sep 2022 05:02:54 -0700 (PDT)
Received: by mail-vs1-xe2d.google.com with SMTP id k2so18011720vsk.8;
        Thu, 08 Sep 2022 05:02:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=xi5m4kuXSzW6uAVBEY65Gx2o6AdM2yTJsU+e7ILFdyc=;
        b=Kmm+qOcwZ8LjykJGCSYH8I8JyBCWYjzGsKsHBes4xvSVp/pwhKb3A0xCfqYEYR5AtE
         wsAalcICsXl78BnHxzbp17nWCNc2YADIn8yl1ASyQ1Oxt4jEYrhfmq042gsWthYeZCfA
         G7IXpQKDcca2LTnxsqNJAFOzg/DKX2ZCHHavtppj1DX/My3mXhYTSw/ySKpzrY8d80b0
         9XumtZr7P69vCWMlnZ/N3QJOMnzDLSLPxwbAKGAAAfouIXFwwENjC/h0UgwVf2VPBttw
         6V7AGsLpNcPVq5ZrQb5tjpwlpUKyfoFEpLH8TWPKLzxb+lKFnMJlGmwWN3r55LSsCX/Z
         H3Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=xi5m4kuXSzW6uAVBEY65Gx2o6AdM2yTJsU+e7ILFdyc=;
        b=txn9VjrZHJ8iLNUo3iRqcdtQwoWd/Sp/131MrcjaPc6jBMZPTp3eMaOeyye2pXAPwR
         GQK/dKJd/P7xAoePvb9aa8s1glWWxFI2v1vgplRtNCkRd1V1mXlgiPrklBT8y52ekQmy
         6DeUfj1nMshMxwCIiH6qP2nFqcaXYdN8awofZ8ZLA8yhqu2eQe5xNkKlQqO0iI5EhkzV
         +lkCUzO8DNtONDYP1OzO44g3vuNc3ftqBWLWPwt7OqXyjzWcVZm3RexQzY1//C3kDIV6
         RDzfI6ghnGqvSEKcpO533tSHBEepnI1Wi3fPN1syePd6cjuCBF/QCVdWNVkIh9KAt851
         cqXQ==
X-Gm-Message-State: ACgBeo2AXjhb/ZxGynBcw677UQQK7e5HfHU1ZDcQF0tqt/fF0mamApko
        23SqMsjm6W4VCGRc/juWxVPJPDxkjjk4SWqorQYVDh5fKE4=
X-Google-Smtp-Source: AA6agR76ErLg1eTPNdrHJXuY6MrtGgP7pJS7JIIgvViR7rqK9FWxjMpdUJXqkFre7efSaFKBZh3d4vl5T20iO0vmAiU=
X-Received: by 2002:a67:a649:0:b0:390:88c5:6a91 with SMTP id
 r9-20020a67a649000000b0039088c56a91mr2913266vsh.3.1662638573123; Thu, 08 Sep
 2022 05:02:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220906183600.1926315-1-teratipally@google.com>
 <20220906183600.1926315-2-teratipally@google.com> <YxnWi5YcuY6Rbodt@kroah.com>
In-Reply-To: <YxnWi5YcuY6Rbodt@kroah.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 8 Sep 2022 15:02:41 +0300
Message-ID: <CAOQ4uxi4UH2pDEe1c6Mn52Qh1GABv2axuQqN=D6QHc7rKwQ2zQ@mail.gmail.com>
Subject: Re: [PATCH] xfs: fix up non-directory creation in SGID directories
To:     Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Varsha Teratipally <teratipally@google.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 8, 2022 at 2:48 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Sep 06, 2022 at 06:36:00PM +0000, Varsha Teratipally wrote:
> > From: Christoph Hellwig <hch@lst.de>
> >
> > XFS always inherits the SGID bit if it is set on the parent inode, while
> > the generic inode_init_owner does not do this in a few cases where it can
> > create a possible security problem, see commit 0fa3ecd87848
> > ("Fix up non-directory creation in SGID directories") for details.
> >
> > Switch XFS to use the generic helper for the normal path to fix this,
> > just keeping the simple field inheritance open coded for the case of the
> > non-sgid case with the bsdgrpid mount option.
> >
> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > Reported-by: Christian Brauner <christian.brauner@ubuntu.com>
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
>
> Why did you not sign off on this if you are forwarding it on?
>
> Also, what is the git id of this commit in Linus's tree (we need that
> hint...)
>
> Please fix both up and resend and get the ack of the stable xfs
> developers on it as well.
>

Varsha,

FWIW, I re-tested the patch on top of v5.10.141,
so when re-posting [PATCH 5.10] you may add:

Tested-by: Amir Goldstein <amir73il@gmail.com>

Darrick or Christoph,

Can you please ACK this patch?

Thanks,
Amir.
