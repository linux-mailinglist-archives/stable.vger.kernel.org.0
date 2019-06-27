Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0815957B78
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 07:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbfF0FbJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jun 2019 01:31:09 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42387 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbfF0FbI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jun 2019 01:31:08 -0400
Received: by mail-pf1-f193.google.com with SMTP id q10so607427pff.9;
        Wed, 26 Jun 2019 22:31:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=22gDyUzpmVQ8U+DOchynH04iAR0fqdEo1S76+8uZmwk=;
        b=S9LFLFS5utYbxWVCTMiclh6xcRAGXN+pCfTmu9rg6MMQdJY5PtSzEHnDglzVXtLIrs
         /IQpPWA1kLPfccMCm1eOqEGM3E+AIxn1bCERaEE/8xEeY+HyAUBQR22nh4g+kthaJ/wJ
         19XJ5D34IUnk9zEFz+7vayLskwKhGpYrvnZ2lX9YfekQ1wJii0TvDNe8qa9v4e6ucpEz
         fWbUtwSmq+tRWCJ/1M8OL0MrHEoSiM1AxAk2dD9YKxZu1m8fKaGm4yCo0ezMxl36ximg
         3Req+Klk4WSpUeBd2ui+rOfHpaXhB4SdSz0BfxHZrisot1XePxM7T7vBPdntyfuYLuOW
         YNMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=22gDyUzpmVQ8U+DOchynH04iAR0fqdEo1S76+8uZmwk=;
        b=o6TLxFqlG9Q90hLF1l+HuwHjhNw2u9HF3z8cVoKS1A8Yl67JEjRjrkqB1JmtU14Zda
         W9hd69+bSojfNCRTS1evVVDN93pHxelWEw0SOXDKbH17u6ppm5z21l+bamI0sgeY7Hj8
         sknjW13w/Z4mlA3svzgHxiZz7PqM7fDH9FqXO7Hu2mBuCqozKnhOv+zTM1Lq2iI9O1Kn
         wMicCwUS4isErhOtl1eyolWueA4atpmv4vnLnUgB4pIQ7+MxuHbXWXdqhCrRrnr/I7dh
         jnZjkeS8+09WBOr/v4YCSxKPS9MnxppNpxPgQ7vbMYZi7ml4lJ5HdbKF1lJU64lnZR/B
         otLA==
X-Gm-Message-State: APjAAAViO0WtyZ4RtZa5iGKfNrMidCZ637pZAOJk1eOeXpQe+/nqCB96
        eJzDID98rNrnWVKYF7GwIeG6YxKpDrISrDOjPTYGvQ==
X-Google-Smtp-Source: APXvYqwWbYaE7J8nHHtV9KVlj9qSfGi12AU3dPYm6GLzreYxAQbogZ2f4gwqFkl1tQ0nKsCbslUEsDTGl7QqSvMtPdM=
X-Received: by 2002:a63:d4c:: with SMTP id 12mr1998940pgn.30.1561613467487;
 Wed, 26 Jun 2019 22:31:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190627045702.8701-1-lsahlber@redhat.com>
In-Reply-To: <20190627045702.8701-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 27 Jun 2019 00:30:56 -0500
Message-ID: <CAH2r5mtLL1rbZNDb+-DOZGWQqtAj9uXgPE+3nGahUsA5vLzc+Q@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix crash for querying symlinks stored as reparse-points
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
Content-Type: multipart/mixed; boundary="00000000000001c8f9058c47786d"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--00000000000001c8f9058c47786d
Content-Type: text/plain; charset="UTF-8"

removed the duplicate definition of IO_REPARSE_TAG_SYMLINK and
tentatively merged to cifs-2.6.git for-next but looks good so far in
testing.


On Wed, Jun 26, 2019 at 11:57 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> We never parsed/returned any data from .get_link() when the object is a windows reparse-point
> containing a symlink. This results in the VFS layer oopsing accessing an uninitialized buffer:
>
> ...
> [  171.407172] Call Trace:
> [  171.408039]  readlink_copy+0x29/0x70
> [  171.408872]  vfs_readlink+0xc1/0x1f0
> [  171.409709]  ? readlink_copy+0x70/0x70
> [  171.410565]  ? simple_attr_release+0x30/0x30
> [  171.411446]  ? getname_flags+0x105/0x2a0
> [  171.412231]  do_readlinkat+0x1b7/0x1e0
> [  171.412938]  ? __ia32_compat_sys_newfstat+0x30/0x30
> ...
>
> Fix this by adding code to handle these buffers and make sure we do return a valid buffer
> to .get_link()
>
> CC: Stable <stable@vger.kernel.org>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/smb2ops.c | 64 +++++++++++++++++++++++++++++++++++++++++++++++++++----
>  fs/cifs/smb2pdu.h | 16 +++++++++++++-
>  2 files changed, 75 insertions(+), 5 deletions(-)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index e921e6511728..74c826007069 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -2385,6 +2385,41 @@ smb2_get_dfs_refer(const unsigned int xid, struct cifs_ses *ses,
>         kfree(dfs_rsp);
>         return rc;
>  }
> +
> +static int
> +parse_reparse_symlink(struct reparse_symlink_data_buffer *symlink_buf,
> +                     u32 plen, char **target_path,
> +                     struct cifs_sb_info *cifs_sb)
> +{
> +       unsigned int sub_len;
> +       unsigned int sub_offset;
> +
> +       /* We only handle Symbolic Link : MS-FSCC 2.1.2.4 */
> +       if (le32_to_cpu(symlink_buf->ReparseTag) != REPARSE_TAG_SYMLINK) {
> +               cifs_dbg(VFS, "srv returned invalid symlink buffer\n");
> +               return -EIO;
> +       }
> +
> +       sub_offset = le16_to_cpu(symlink_buf->SubstituteNameOffset);
> +       sub_len = le16_to_cpu(symlink_buf->SubstituteNameLength);
> +       if (sub_offset + 20 > plen ||
> +           sub_offset + sub_len + 20 > plen) {
> +               cifs_dbg(VFS, "srv returned malformed symlink buffer\n");
> +               return -EIO;
> +       }
> +
> +       *target_path = cifs_strndup_from_utf16(
> +                               symlink_buf->PathBuffer + sub_offset,
> +                               sub_len, true, cifs_sb->local_nls);
> +       if (!(*target_path))
> +               return -ENOMEM;
> +
> +       convert_delimiter(*target_path, '/');
> +       cifs_dbg(FYI, "%s: target path: %s\n", __func__, *target_path);
> +
> +       return 0;
> +}
> +
>  #define SMB2_SYMLINK_STRUCT_SIZE \
>         (sizeof(struct smb2_err_rsp) - 1 + sizeof(struct smb2_symlink_err_rsp))
>
> @@ -2414,11 +2449,13 @@ smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
>         struct kvec close_iov[1];
>         struct smb2_create_rsp *create_rsp;
>         struct smb2_ioctl_rsp *ioctl_rsp;
> -       char *ioctl_buf;
> +       struct reparse_data_buffer *reparse_buf;
>         u32 plen;
>
>         cifs_dbg(FYI, "%s: path: %s\n", __func__, full_path);
>
> +       *target_path = NULL;
> +
>         if (smb3_encryption_required(tcon))
>                 flags |= CIFS_TRANSFORM_REQ;
>
> @@ -2496,17 +2533,36 @@ smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
>         if ((rc == 0) && (is_reparse_point)) {
>                 /* See MS-FSCC 2.3.23 */
>
> -               ioctl_buf = (char *)ioctl_rsp + le32_to_cpu(ioctl_rsp->OutputOffset);
> +               reparse_buf = (struct reparse_data_buffer *)
> +                       ((char *)ioctl_rsp +
> +                        le32_to_cpu(ioctl_rsp->OutputOffset));
>                 plen = le32_to_cpu(ioctl_rsp->OutputCount);
>
>                 if (plen + le32_to_cpu(ioctl_rsp->OutputOffset) >
>                     rsp_iov[1].iov_len) {
> -                       cifs_dbg(VFS, "srv returned invalid ioctl length: %d\n", plen);
> +                       cifs_dbg(VFS, "srv returned invalid ioctl len: %d\n",
> +                                plen);
> +                       rc = -EIO;
> +                       goto querty_exit;
> +               }
> +
> +               if (plen < 8) {
> +                       cifs_dbg(VFS, "reparse buffer is too small. Must be "
> +                                "at least 8 bytes but was %d\n", plen);
> +                       rc = -EIO;
> +                       goto querty_exit;
> +               }
> +
> +               if (plen < le16_to_cpu(reparse_buf->ReparseDataLength) + 8) {
> +                       cifs_dbg(VFS, "srv returned invalid reparse buf "
> +                                "length: %d\n", plen);
>                         rc = -EIO;
>                         goto querty_exit;
>                 }
>
> -               /* Do stuff with ioctl_buf/plen */
> +               rc = parse_reparse_symlink(
> +                       (struct reparse_symlink_data_buffer *)reparse_buf,
> +                       plen, target_path, cifs_sb);
>                 goto querty_exit;
>         }
>
> diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
> index c7d5813bebd8..31f7c56e0ed8 100644
> --- a/fs/cifs/smb2pdu.h
> +++ b/fs/cifs/smb2pdu.h
> @@ -888,6 +888,8 @@ struct file_allocated_range_buffer {
>
>  /* struct fsctl_reparse_info_req is empty, only response structs (see below) */
>
> +#define REPARSE_TAG_SYMLINK 0xa000000c
> +
>  struct reparse_data_buffer {
>         __le32  ReparseTag;
>         __le16  ReparseDataLength;
> @@ -914,7 +916,19 @@ struct reparse_mount_point_data_buffer {
>         __u8    PathBuffer[0]; /* Variable Length */
>  } __packed;
>
> -/* See MS-FSCC 2.1.2.4 and cifspdu.h for struct reparse_symlink_data */
> +#define SYMLINK_FLAG_RELATIVE 0x00000001
> +
> +struct reparse_symlink_data_buffer {
> +       __le32  ReparseTag;
> +       __le16  ReparseDataLength;
> +       __u16   Reserved;
> +       __le16  SubstituteNameOffset;
> +       __le16  SubstituteNameLength;
> +       __le16  PrintNameOffset;
> +       __le16  PrintNameLength;
> +       __le32  Flags;
> +       __u8    PathBuffer[0]; /* Variable Length */
> +} __packed;
>
>  /* See MS-FSCC 2.1.2.6 and cifspdu.h for struct reparse_posix_data */
>
> --
> 2.13.6
>


-- 
Thanks,

Steve

--00000000000001c8f9058c47786d
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-fix-crash-for-querying-symlinks-stored-as-repar.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-fix-crash-for-querying-symlinks-stored-as-repar.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jxe8b2pp0>
X-Attachment-Id: f_jxe8b2pp0

RnJvbSAyY2NhYjM5YjkyNTkwZTYyYTNhODhjOGY5NGU2YTRmYjdiM2Q5ODk1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSb25uaWUgU2FobGJlcmcgPGxzYWhsYmVyQHJlZGhhdC5jb20+
CkRhdGU6IFRodSwgMjcgSnVuIDIwMTkgMTQ6NTc6MDIgKzEwMDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBmaXggY3Jhc2ggcXVlcnlpbmcgc3ltbGlua3Mgc3RvcmVkIGFzCnJlcGFyc2UtcG9pbnRz
CgpXZSBuZXZlciBwYXJzZWQvcmV0dXJuZWQgYW55IGRhdGEgZnJvbSAuZ2V0X2xpbmsoKSB3aGVu
IHRoZSBvYmplY3QgaXMgYSB3aW5kb3dzIHJlcGFyc2UtcG9pbnQKY29udGFpbmluZyBhIHN5bWxp
bmsuIFRoaXMgcmVzdWx0cyBpbiB0aGUgVkZTIGxheWVyIG9vcHNpbmcgYWNjZXNzaW5nIGFuIHVu
aW5pdGlhbGl6ZWQgYnVmZmVyOgoKLi4uClsgIDE3MS40MDcxNzJdIENhbGwgVHJhY2U6ClsgIDE3
MS40MDgwMzldICByZWFkbGlua19jb3B5KzB4MjkvMHg3MApbICAxNzEuNDA4ODcyXSAgdmZzX3Jl
YWRsaW5rKzB4YzEvMHgxZjAKWyAgMTcxLjQwOTcwOV0gID8gcmVhZGxpbmtfY29weSsweDcwLzB4
NzAKWyAgMTcxLjQxMDU2NV0gID8gc2ltcGxlX2F0dHJfcmVsZWFzZSsweDMwLzB4MzAKWyAgMTcx
LjQxMTQ0Nl0gID8gZ2V0bmFtZV9mbGFncysweDEwNS8weDJhMApbICAxNzEuNDEyMjMxXSAgZG9f
cmVhZGxpbmthdCsweDFiNy8weDFlMApbICAxNzEuNDEyOTM4XSAgPyBfX2lhMzJfY29tcGF0X3N5
c19uZXdmc3RhdCsweDMwLzB4MzAKLi4uCgpGaXggdGhpcyBieSBhZGRpbmcgY29kZSB0byBoYW5k
bGUgdGhlc2UgYnVmZmVycyBhbmQgbWFrZSBzdXJlIHdlIGRvIHJldHVybiBhIHZhbGlkIGJ1ZmZl
cgp0byAuZ2V0X2xpbmsoKQoKQ0M6IFN0YWJsZSA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4KU2ln
bmVkLW9mZi1ieTogUm9ubmllIFNhaGxiZXJnIDxsc2FobGJlckByZWRoYXQuY29tPgpTaWduZWQt
b2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lm
cy9zbWIyb3BzLmMgfCA2NCArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKy0tLQogZnMvY2lmcy9zbWIycGR1LmggfCAxNiArKysrKysrKysrKy0KIDIgZmlsZXMgY2hh
bmdlZCwgNzUgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9j
aWZzL3NtYjJvcHMuYyBiL2ZzL2NpZnMvc21iMm9wcy5jCmluZGV4IDNmZGM2YTQxYjMwNC4uZjli
ZDFlNmUxNWM2IDEwMDY0NAotLS0gYS9mcy9jaWZzL3NtYjJvcHMuYworKysgYi9mcy9jaWZzL3Nt
YjJvcHMuYwpAQCAtMjM3Miw2ICsyMzcyLDQxIEBAIHNtYjJfZ2V0X2Rmc19yZWZlcihjb25zdCB1
bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc19zZXMgKnNlcywKIAlrZnJlZShkZnNfcnNwKTsK
IAlyZXR1cm4gcmM7CiB9CisKK3N0YXRpYyBpbnQKK3BhcnNlX3JlcGFyc2Vfc3ltbGluayhzdHJ1
Y3QgcmVwYXJzZV9zeW1saW5rX2RhdGFfYnVmZmVyICpzeW1saW5rX2J1ZiwKKwkJICAgICAgdTMy
IHBsZW4sIGNoYXIgKip0YXJnZXRfcGF0aCwKKwkJICAgICAgc3RydWN0IGNpZnNfc2JfaW5mbyAq
Y2lmc19zYikKK3sKKwl1bnNpZ25lZCBpbnQgc3ViX2xlbjsKKwl1bnNpZ25lZCBpbnQgc3ViX29m
ZnNldDsKKworCS8qIFdlIG9ubHkgaGFuZGxlIFN5bWJvbGljIExpbmsgOiBNUy1GU0NDIDIuMS4y
LjQgKi8KKwlpZiAobGUzMl90b19jcHUoc3ltbGlua19idWYtPlJlcGFyc2VUYWcpICE9IElPX1JF
UEFSU0VfVEFHX1NZTUxJTkspIHsKKwkJY2lmc19kYmcoVkZTLCAic3J2IHJldHVybmVkIGludmFs
aWQgc3ltbGluayBidWZmZXJcbiIpOworCQlyZXR1cm4gLUVJTzsKKwl9CisKKwlzdWJfb2Zmc2V0
ID0gbGUxNl90b19jcHUoc3ltbGlua19idWYtPlN1YnN0aXR1dGVOYW1lT2Zmc2V0KTsKKwlzdWJf
bGVuID0gbGUxNl90b19jcHUoc3ltbGlua19idWYtPlN1YnN0aXR1dGVOYW1lTGVuZ3RoKTsKKwlp
ZiAoc3ViX29mZnNldCArIDIwID4gcGxlbiB8fAorCSAgICBzdWJfb2Zmc2V0ICsgc3ViX2xlbiAr
IDIwID4gcGxlbikgeworCQljaWZzX2RiZyhWRlMsICJzcnYgcmV0dXJuZWQgbWFsZm9ybWVkIHN5
bWxpbmsgYnVmZmVyXG4iKTsKKwkJcmV0dXJuIC1FSU87CisJfQorCisJKnRhcmdldF9wYXRoID0g
Y2lmc19zdHJuZHVwX2Zyb21fdXRmMTYoCisJCQkJc3ltbGlua19idWYtPlBhdGhCdWZmZXIgKyBz
dWJfb2Zmc2V0LAorCQkJCXN1Yl9sZW4sIHRydWUsIGNpZnNfc2ItPmxvY2FsX25scyk7CisJaWYg
KCEoKnRhcmdldF9wYXRoKSkKKwkJcmV0dXJuIC1FTk9NRU07CisKKwljb252ZXJ0X2RlbGltaXRl
cigqdGFyZ2V0X3BhdGgsICcvJyk7CisJY2lmc19kYmcoRllJLCAiJXM6IHRhcmdldCBwYXRoOiAl
c1xuIiwgX19mdW5jX18sICp0YXJnZXRfcGF0aCk7CisKKwlyZXR1cm4gMDsKK30KKwogI2RlZmlu
ZSBTTUIyX1NZTUxJTktfU1RSVUNUX1NJWkUgXAogCShzaXplb2Yoc3RydWN0IHNtYjJfZXJyX3Jz
cCkgLSAxICsgc2l6ZW9mKHN0cnVjdCBzbWIyX3N5bWxpbmtfZXJyX3JzcCkpCiAKQEAgLTI0MDEs
MTEgKzI0MzYsMTMgQEAgc21iMl9xdWVyeV9zeW1saW5rKGNvbnN0IHVuc2lnbmVkIGludCB4aWQs
IHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJc3RydWN0IGt2ZWMgY2xvc2VfaW92WzFdOwogCXN0
cnVjdCBzbWIyX2NyZWF0ZV9yc3AgKmNyZWF0ZV9yc3A7CiAJc3RydWN0IHNtYjJfaW9jdGxfcnNw
ICppb2N0bF9yc3A7Ci0JY2hhciAqaW9jdGxfYnVmOworCXN0cnVjdCByZXBhcnNlX2RhdGFfYnVm
ZmVyICpyZXBhcnNlX2J1ZjsKIAl1MzIgcGxlbjsKIAogCWNpZnNfZGJnKEZZSSwgIiVzOiBwYXRo
OiAlc1xuIiwgX19mdW5jX18sIGZ1bGxfcGF0aCk7CiAKKwkqdGFyZ2V0X3BhdGggPSBOVUxMOwor
CiAJaWYgKHNtYjNfZW5jcnlwdGlvbl9yZXF1aXJlZCh0Y29uKSkKIAkJZmxhZ3MgfD0gQ0lGU19U
UkFOU0ZPUk1fUkVROwogCkBAIC0yNDgzLDE3ICsyNTIwLDM2IEBAIHNtYjJfcXVlcnlfc3ltbGlu
ayhjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCWlmICgo
cmMgPT0gMCkgJiYgKGlzX3JlcGFyc2VfcG9pbnQpKSB7CiAJCS8qIFNlZSBNUy1GU0NDIDIuMy4y
MyAqLwogCi0JCWlvY3RsX2J1ZiA9IChjaGFyICopaW9jdGxfcnNwICsgbGUzMl90b19jcHUoaW9j
dGxfcnNwLT5PdXRwdXRPZmZzZXQpOworCQlyZXBhcnNlX2J1ZiA9IChzdHJ1Y3QgcmVwYXJzZV9k
YXRhX2J1ZmZlciAqKQorCQkJKChjaGFyICopaW9jdGxfcnNwICsKKwkJCSBsZTMyX3RvX2NwdShp
b2N0bF9yc3AtPk91dHB1dE9mZnNldCkpOwogCQlwbGVuID0gbGUzMl90b19jcHUoaW9jdGxfcnNw
LT5PdXRwdXRDb3VudCk7CiAKIAkJaWYgKHBsZW4gKyBsZTMyX3RvX2NwdShpb2N0bF9yc3AtPk91
dHB1dE9mZnNldCkgPgogCQkgICAgcnNwX2lvdlsxXS5pb3ZfbGVuKSB7Ci0JCQljaWZzX2RiZyhW
RlMsICJzcnYgcmV0dXJuZWQgaW52YWxpZCBpb2N0bCBsZW5ndGg6ICVkXG4iLCBwbGVuKTsKKwkJ
CWNpZnNfZGJnKFZGUywgInNydiByZXR1cm5lZCBpbnZhbGlkIGlvY3RsIGxlbjogJWRcbiIsCisJ
CQkJIHBsZW4pOworCQkJcmMgPSAtRUlPOworCQkJZ290byBxdWVydHlfZXhpdDsKKwkJfQorCisJ
CWlmIChwbGVuIDwgOCkgeworCQkJY2lmc19kYmcoVkZTLCAicmVwYXJzZSBidWZmZXIgaXMgdG9v
IHNtYWxsLiBNdXN0IGJlICIKKwkJCQkgImF0IGxlYXN0IDggYnl0ZXMgYnV0IHdhcyAlZFxuIiwg
cGxlbik7CisJCQlyYyA9IC1FSU87CisJCQlnb3RvIHF1ZXJ0eV9leGl0OworCQl9CisKKwkJaWYg
KHBsZW4gPCBsZTE2X3RvX2NwdShyZXBhcnNlX2J1Zi0+UmVwYXJzZURhdGFMZW5ndGgpICsgOCkg
eworCQkJY2lmc19kYmcoVkZTLCAic3J2IHJldHVybmVkIGludmFsaWQgcmVwYXJzZSBidWYgIgor
CQkJCSAibGVuZ3RoOiAlZFxuIiwgcGxlbik7CiAJCQlyYyA9IC1FSU87CiAJCQlnb3RvIHF1ZXJ0
eV9leGl0OwogCQl9CiAKLQkJLyogRG8gc3R1ZmYgd2l0aCBpb2N0bF9idWYvcGxlbiAqLworCQly
YyA9IHBhcnNlX3JlcGFyc2Vfc3ltbGluaygKKwkJCShzdHJ1Y3QgcmVwYXJzZV9zeW1saW5rX2Rh
dGFfYnVmZmVyICopcmVwYXJzZV9idWYsCisJCQlwbGVuLCB0YXJnZXRfcGF0aCwgY2lmc19zYik7
CiAJCWdvdG8gcXVlcnR5X2V4aXQ7CiAJfQogCmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJwZHUu
aCBiL2ZzL2NpZnMvc21iMnBkdS5oCmluZGV4IGM3ZDU4MTNiZWJkOC4uMzFmN2M1NmUwZWQ4IDEw
MDY0NAotLS0gYS9mcy9jaWZzL3NtYjJwZHUuaAorKysgYi9mcy9jaWZzL3NtYjJwZHUuaApAQCAt
OTE0LDcgKzkxNiwxOSBAQCBzdHJ1Y3QgcmVwYXJzZV9tb3VudF9wb2ludF9kYXRhX2J1ZmZlciB7
CiAJX191OAlQYXRoQnVmZmVyWzBdOyAvKiBWYXJpYWJsZSBMZW5ndGggKi8KIH0gX19wYWNrZWQ7
CiAKLS8qIFNlZSBNUy1GU0NDIDIuMS4yLjQgYW5kIGNpZnNwZHUuaCBmb3Igc3RydWN0IHJlcGFy
c2Vfc3ltbGlua19kYXRhICovCisjZGVmaW5lIFNZTUxJTktfRkxBR19SRUxBVElWRSAweDAwMDAw
MDAxCisKK3N0cnVjdCByZXBhcnNlX3N5bWxpbmtfZGF0YV9idWZmZXIgeworCV9fbGUzMglSZXBh
cnNlVGFnOworCV9fbGUxNglSZXBhcnNlRGF0YUxlbmd0aDsKKwlfX3UxNglSZXNlcnZlZDsKKwlf
X2xlMTYJU3Vic3RpdHV0ZU5hbWVPZmZzZXQ7CisJX19sZTE2CVN1YnN0aXR1dGVOYW1lTGVuZ3Ro
OworCV9fbGUxNglQcmludE5hbWVPZmZzZXQ7CisJX19sZTE2CVByaW50TmFtZUxlbmd0aDsKKwlf
X2xlMzIJRmxhZ3M7CisJX191OAlQYXRoQnVmZmVyWzBdOyAvKiBWYXJpYWJsZSBMZW5ndGggKi8K
K30gX19wYWNrZWQ7CiAKIC8qIFNlZSBNUy1GU0NDIDIuMS4yLjYgYW5kIGNpZnNwZHUuaCBmb3Ig
c3RydWN0IHJlcGFyc2VfcG9zaXhfZGF0YSAqLwogCi0tIAoyLjIwLjEKCg==
--00000000000001c8f9058c47786d--
